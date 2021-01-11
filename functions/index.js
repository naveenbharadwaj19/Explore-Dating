// * region - asia-south1 - Mumbai

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {Storage} = require("@google-cloud/storage")
admin.initializeApp();

// * assign memory timeout , region here:
// * DUCS -> deleteUserCloudStorage
const runTimeForDUCS = {timeoutSeconds: 200,
	memory: '512MB'}
const nearRegion = "asia-south1"
// -------------------------------------------

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// * delete user cloud storage
exports.deleteUserCloudStorage = functions.region("asia-south1").runWith(runTimeForDUCS).auth.user().onDelete(async (user) => {
  try {
    var userId = user.uid;
    console.log("User id : " + userId);
    // * declare bucket name
    // ! check for project id while adding domain name :
    const storage = new Storage({projectId:"exploreapp-3572c"});
    const bucket = storage.bucket('gs://exploreapp-3572c.appspot.com');
    await bucket.deleteFiles({
      force:true,
      prefix:"Userphotos/" + userId
    });
    console.log("Photos deleted successfully");
    } 
   catch (error) {
    console.log("Error in processing : " + error.toString());
  }
});

// * Trigger when isdeleted == true && islogin == true in firestore -> these should happen in when user auth deleted
// * will show error to user 
exports.isDelLogFieldUpdated = functions.region(nearRegion).auth.user().onDelete((user)=>{
  try{
  var userId = user.uid;
  console.log("User id : " + userId);
  var check = admin.firestore.DocumentReference
  } catch (error) {
    console.log("er");
  }
});