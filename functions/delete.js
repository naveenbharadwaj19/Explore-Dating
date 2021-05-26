// todo manage all deletes of clients
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nearRegion = "asia-south1";

const typingRTDBUrl =
  "https://explore-dating-default-rtdb.asia-southeast1.firebasedatabase.app/";

// delete chats data nad typing data in rtdb
exports.deleteChatsTyping = functions
  .region(nearRegion)
  .runWith({ memory: "256MB", timeoutSeconds: 200 })
  .auth.user()
  .onDelete(async (user) => {
    try {
      var counter = 0; // track how many docs deleted
      var firestore = admin.firestore();
      var rtdb = admin.database();
      var datas = await firestore
        .collectionGroup("Chats")
        .where("uids", "array-contains", user.uid)
        .limit(100)
        .get(); // only 100 docs
      // ! batch writing is not working
      var batch = firestore.batch();
      datas.docs.forEach(async (item) => {
        var deepPath = item.ref.path; // chats/auto-id/chats/rooms...
        var outerPath = deepPath.split("/")[1]; // auto-id
        batch.delete(deepPath);
        batch.delete(`Chats/${outerPath}`);
        await rtdb.refFromURL(typingRTDBUrl).child(outerPath).remove(); // remove typing data from rtdb
        counter++;
      });
      await batch.commit(); // ! batch writing is not working
      console.log(
        `${counter} deleted from chats and typing of the user ${user.uid}`
      );
    } catch (error) {
      console.log(
        `Error in deletation of chats and typing of the user ${
          user.uid
        } : ${error.toString()}`
      );
    }
  });

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
