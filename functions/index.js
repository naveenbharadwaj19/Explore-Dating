// * region - asia-south1 - Mumbai

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
admin.initializeApp();

// * assign memory timeout , region here:
// * DUCS -> deleteUserCloudStorage
const runTimeForDUCS = { timeoutSeconds: 200, memory: "512MB" };
// * run time for isdeleted field in firestore
const runTimeForIsdeletedField = { timeoutSeconds: 60, memory: "256MB" };

const nearRegion = "asia-south1";
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
      await admin.auth().deleteUser(uid)
      console.log("User account deleted successfully");
    }
  } catch (error) {
    console.log("Error :" + error.toString());
  }
});