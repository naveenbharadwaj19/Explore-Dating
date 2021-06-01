// todo manage all deletes of clients
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const nearRegion = "asia-south1";

const typingRTDBUrl =
  "https://explore-dating-default-rtdb.asia-southeast1.firebasedatabase.app/";

const reportRTDBUrl =
  "https://report-block.asia-southeast1.firebasedatabase.app/";
const starsRTDBUrl =
  "https://star-informations.asia-southeast1.firebasedatabase.app/";

//  delete user cloud storage
exports.deleteUserCloudStorage = functions
  .region(nearRegion)
  .runWith({ timeoutSeconds: 200, memory: "512MB" })
  .auth.user()
  .onDelete(async (user) => {
    try {
      var userId = user.uid;
      console.log("User id : " + userId);
      //  declare bucket name
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

//  deletes user match making details
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

// delete -> chats,stars rtdb,reports rtdb, chatphotos storage
exports.iterateUserDelete = functions
  .region(nearRegion)
  .runWith({ memory: "512MB", timeoutSeconds: 240 })
  .firestore.document("Users/{userId}")
  .onDelete(async (snap, context) => {
    try {
      const uid = snap.get("bio.user_id");
      var storeDocIDs = [];
      // chats
      const firestore = admin.firestore();
      var datas = await firestore
        .collectionGroup("Chats")
        .where("uids", "array-contains", uid)
        .where("show_this", "==", true)
        .orderBy("latest_time","desc")
        .limit(500)
        .get();
      var batch = firestore.batch();
      datas.docs.forEach((item) => {
        var path = item.ref.path;
        let documentRef = firestore.doc(path);
        var docId = item.ref.path.split("/")[1];
        storeDocIDs.push(docId);
        // update the docs
        batch.update(documentRef, {
          show_this: false,
        });
      });
      await batch.commit();
      deleteStarsInfo(uid);
      deleteReportInfo(uid);
      deleteTypingRTDB(storeDocIDs);
      deleteChatPhotos(storeDocIDs);
      console.log("Iterate delete success");
    } catch (error) {
      console.log(`Error in iterateUserDelete : ${error.toString()}`);
    }
  });

/**
 * @param  {string} uid
 */
async function deleteStarsInfo(uid) {
  try {
    var db = admin.app().database(starsRTDBUrl).ref();
    await db.child(uid).remove();
  } catch (error) {
    console.log(`Error in deleteStarsInfo : ${error.toString()}`);
  }
}
/**
 * @param  {string} uid
 */
async function deleteReportInfo(uid) {
  try {
    var db = admin.app().database(reportRTDBUrl).ref();
    await db.child(`explicit_reports/${uid}`).remove();
    await db.child(`gross_reports/${uid}`).remove();
  } catch (error) {
    console.log(`Error in deleteReportsInfo rtdb : ${error.toString()}`);
  }
}

async function deleteTypingRTDB(docIds) {
  try {
    var db = admin.app().database(typingRTDBUrl).ref();
    docIds.forEach(async (item) => {
      await db.child(item).remove();
    });
  } catch (error) {
    console.log(`Error in deleteTypingRTDB rtdb : ${error.toString()}`);
  }
}

async function deleteChatPhotos(docIds) {
  try {
    const storage = new Storage({ projectId: "explore-dating" });
    const bucket = storage.bucket("gs://explore-dating.appspot.com");
    docIds.forEach(async (item) => {
      await bucket.deleteFiles({ force: true, prefix: `Chatphotos/${item}` });
    });
  } catch (error) {
    console.log(`Error in deleteChatPhotos storage : ${error.toString()}`);
  }
}
