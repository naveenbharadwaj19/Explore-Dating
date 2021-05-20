//  region - asia-south1 - Mumbai

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
admin.initializeApp();

//  assign memory timeout , region here:
//  DUCS -> deleteUserCloudStorage
const runTimeForDUCS = { timeoutSeconds: 200, memory: "512MB" };
//  run time for isdeleted field in firestore
const runTimeForIsdeletedField = { timeoutSeconds: 60, memory: "256MB" };

const nearRegion = "asia-south1";

const rtdbUrl =
  "https://explore-dating-default-rtdb.asia-southeast1.firebasedatabase.app/";
// -------------------------------------------

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", { structuredData: true });
//   response.send("Hello from Firebase!");
// });

// * delete user cloud storage
exports.deleteUserCloudStorage = functions
  .region(nearRegion)
  .runWith(runTimeForDUCS)
  .auth.user()
  .onDelete(async (user) => {
    try {
      var userId = user.uid;
      console.log("User id : " + userId);
      // * declare bucket name
      // ! check for project id while adding domain name :
      const storage = new Storage({ projectId: "explore-dating" });
      const bucket = storage.bucket("gs://explore-dating.appspot.com");
      await bucket.deleteFiles({
        force: true,
        prefix: "Userphotos/" + userId,
      });
      console.log("Photos deleted successfully");
    } catch (error) {
      console.log("Error in processing : " + error.toString());
    }
  });

// * deletes user match making details
exports.deleteUserMatchMaking = functions
  .region(nearRegion)
  .runWith({ timeoutSeconds: 60, memory: "128MB" })
  .firestore.document("Users/{userId}")
  .onDelete(async (snap, context) => {
    try {
      var userId = snap.get("bio.user_id");
      var gender = snap.get("bio.gender").toString();
      console.log("User id : " + userId);
      const searchCurrentUserDb = await admin
        .firestore()
        .collection("Matchmaking/simplematch/MenWomen")
        .where("uid", "==", userId)
        .get();
      searchCurrentUserDb.docs.forEach((value) => {
        var documentId = value.id;
        var fullPath = value.ref.path;
        console.log("Document id retrieved : " + documentId);
        admin.firestore().doc(fullPath).delete();
        console.log("Deleted user data in matchmaking");
      });
    } catch (error) {
      console.log("Error :" + error.toString());
    }
  });

// * disable user account
exports.disableUserAccount = functions.https.onCall(async (data, context) => {
  try {
    const uid = context.auth.uid;
    if (uid.length !== 0) {
      console.log("User uid : " + uid);
      await admin.auth().updateUser(context.auth.uid, {
        disabled: true,
      });
      console.log("User account disabled successfully");
    }
  } catch (error) {
    console.log("Error :" + error.toString());
  }
});

// * delete user account
exports.deleteUserAccount = functions.https.onCall(async (data, context) => {
  try {
    const uid = context.auth.uid;
    if (uid.length !== 0) {
      console.log("User uid : " + uid);
      await admin.auth().deleteUser(uid);
      console.log("User account deleted successfully");
    }
  } catch (error) {
    console.log("Error :" + error.toString());
  }
});

// * send push notification when heart is pressed -> FCM
exports.notifyUsersFCM = functions.https.onCall(async (data, context) => {
  try {
    var token = data.token;
    var title = data.title.toString();
    var body = data.body.toString();
    console.log("FCM token :" + token);
    var sendmessageFCM = await admin.messaging().send({
      token: token,
      notification: {
        title: title,
        body: body,
      },
    });
    console.log(sendmessageFCM);
    return "Push notification sent";
  } catch (error) {
    console.log("Error in notifing Users -> FCM : " + error.toString());
    return "Push notification failed";
  }
});

//  automatic unmatch
exports.automaticUnMatch = functions
  .runWith({ memory: "256MB", timeoutSeconds: 180 })
  .https.onCall(async (data, context) => {
    try {
      const uid = context.auth.uid;
      var pathToDelete = data.deletePath;
      //  loop the list
      if (pathToDelete.length !== 0) {
        pathToDelete.forEach(async (item, index) => {
          await admin.firestore().doc(item).delete(); // delete chats/id/chats/room1
          var overAllDoc = item.split("/")[1]; // chats/autoid
          await admin
            .firestore()
            .doc("Chats/" + overAllDoc)
            .delete(); // delete chats/id
          await admin.database().refFromURL(rtdbUrl).child(overAllDoc).remove(); // remove from rtdb
        });
        console.log("Sucessfully deleted user " + uid + " chats");
        return "Sucessfully deleted user " + uid + " chats";
      }
      return "Something went wrong in if statement";
    } catch (error) {
      console.log("Error in automatic unmatch : " + error.toString());
      return "Cannot unmatch";
    }
  });

// unmatch individual chats
exports.unmatchIndividualChats = functions
  .runWith({ memory: "256MB", timeoutSeconds: 180 })
  .https.onCall(async (data, context) => {
    try {
      const uid = context.auth.uid;
      var pathToDelete = data.path; // path to delete
      var docId = pathToDelete.split("/")[1];
      // get all room docs from the path
      var getAllRooms = await admin.firestore().collection(pathToDelete).get();
      getAllRooms.docs.forEach(async (item) => {
        var deleteRoom = item.ref.path;
        await admin.firestore().doc(deleteRoom).delete(); // delete rooms
      });
      await admin
        .firestore()
        .doc("Chats/" + docId)
        .delete(); // delete the parent doc chats/auto-id
      admin.database().refFromURL(rtdbUrl).child(docId).remove(); // delete doc if from rtdb
      console.log("Successfully deleted personal chat of the user : " + uid);
      return "Successfully deleted personal chat of the user : " + uid;
    } catch (error) {
      console.log("Error in unmatch individual chats : " + error.toString());
      return "Cannot unmatch";
    }
  });

  
// upload head photo to starred users
// replicate head photo
exports.replicateHeadPhoto = functions
  .runWith({ memory: "256MB", timeoutSeconds: 240 })
  .https.onCall(async (data, context) => {
    try {
      const uid = context.auth.uid;
      var headPhotoUrl = data.headPhotoUrl; // url of head photo
      var query = await admin
        .firestore()
        .collectionGroup("Chats")
        .where("uids", "array-contains", uid)
        .where("show_this", "==", true)
        .orderBy("latest_time", "desc")
        .limit(100) // 100 max docs
        .get();
      var datas = [];
      query.docs.forEach((item) => {
        var path = item.ref.path; // path
        var headPhotoList = item.get("head_photos"); // head photo list
        var myheadPhotoData = headPhotoList.find((e) => e["uid"] === uid);
        var oppositeHeadPhotoData = headPhotoList.find((e) => e["uid"] !== uid);
        myheadPhotoData["head_photo"] = headPhotoUrl;
        var mapData = {
          path: path,
          head_photos: [myheadPhotoData, oppositeHeadPhotoData],
        };
        datas.push(mapData); // append to list
      });
      if (datas.length > 0) {
        // process batch is datas in not empty
        let writeBatch = admin.firestore().batch();
        datas.forEach(async (item) => {
          // update the photo data to all the user chats
          let doucmentRef = admin.firestore().doc(item["path"]); // chats/id/chats/rooms..
          writeBatch.update(doucmentRef, { head_photos: item["head_photos"] }); // update the document
        });
        await writeBatch.commit(); // commit the batch
        return `Head photo replicated in ${datas.length} chat docs of the user ${uid}`;
      }
      return `No head photo is replicated.No chat docs found of the user ${uid}`;
    } catch (error) {
      console.log("Error in replicate head photo: " + error.toString());
      return "Cannot replicate head photo";
    }
  });
