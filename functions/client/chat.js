// todo all chat functions
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const nearRegion = "asia-south1";

const rtdbUrl =
  "https://explore-dating-default-rtdb.asia-southeast1.firebasedatabase.app/";

const starsRTDBUrl =
  "https://star-informations.asia-southeast1.firebasedatabase.app/";

//  automatic unmatch
exports.automaticUnMatch = functions
  .runWith({ memory: "256MB", timeoutSeconds: 180 })
  .https.onCall(async (data, context) => {
    try {
      const uid = context.auth.uid;
      var deleteDatas = data.deleteDatas;
      var typingDb = admin.app().database(rtdbUrl).ref();
      var starDb = admin.app().database(starsRTDBUrl).ref();
      //  loop the list
      if (deleteDatas.length !== 0) {
        deleteDatas.forEach(async (item) => {
          await admin.firestore().doc(item["path"]).delete(); // delete chats/id/chats/room1
          var overAllDoc = item["path"].split("/")[1]; // chats/autoid
          await admin
            .firestore()
            .doc("Chats/" + overAllDoc)
            .delete(); // delete chats/id
          await typingDb.child(overAllDoc).remove(); // remove data from typing rtdb
          // remove opposite uids in my uid
          await starDb.child(`${uid}/stars/${item["opposite_uid"]}`).remove();
          // remove my uid in opposite uids
          await starDb.child(`${item["opposite_uid"]}/stars/${uid}`).remove();
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
      var oppositeUid = data.oppositeUid;
      var typingDb = admin.app().database(rtdbUrl).ref();
      var starDb = admin.app().database(starsRTDBUrl).ref();
      var docId = pathToDelete.split("/")[1];
      // get all room docs from the path
      var getAllRooms = await admin
        .firestore()
        .collection(`Chats/${docId}/Chats`)
        .get();
      getAllRooms.docs.forEach(async (item) => {
        var deleteRoom = item.ref.path;
        await admin.firestore().doc(deleteRoom).delete(); // delete rooms
      });
      await admin
        .firestore()
        .doc("Chats/" + docId)
        .delete(); // delete the parent doc chats/auto-id
      await typingDb.child(docId).remove(); // delete typing data from rtdb
      // remove opposite uid in my uid
      await starDb.child(`${uid}/stars/${oppositeUid}`).remove();
      // remove my uid in opposite uid
      await starDb.child(`${oppositeUid}/stars/${uid}`).remove();
      // remove photos from storage
      // ! check for project id while adding domain name :
      const storage = new Storage({ projectId: "explore-dating" });
      const bucket = storage.bucket("gs://explore-dating.appspot.com");
      await bucket.deleteFiles({
        force: true,
        prefix: `Chatphotos/${docId}`,
      });

      console.log(
        `Successfully deleted personal chat of the users : ${uid} and ${oppositeUid}`
      );

      return `Successfully deleted personal chat of the users : ${uid} and ${oppositeUid}`;
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
