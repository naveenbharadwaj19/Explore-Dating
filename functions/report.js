// todo report functions
// total nine report functions
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nearRegion = "asia-south1";

// fake profile
// only updates
exports.fakeProfile = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Fakeprofile/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe > 10) {
        await updateTrigger.update({
          is_disabled: false,
          is_delete: true,
        });
        await admin.auth().updateUser(uid, {disabled: false}) // revoke disable coz is_delete is tirggered
        console.log(
          `${uid} violated more than 10 triggers.So deleting the account`
        );
      } else if (reportedMe === 3) {
        await updateTrigger.update({
          is_disabled: true,
        });
        console.log(`${uid} account disabled`);
      }
    } catch (error) {
      console.log(`Error in streaming fake profile : ${error.toString()}`);
    }
  });

// inapporiatecontent/sexuallyexplicitcontent
// sexuallyexplicitcontent
// watch all CRUD
exports.sexuallyExplicitContent = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Inapporiatecontent/4content/Sexuallyexplicitcontent/docdata"
  )
  .onWrite(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe === 1) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} sending sexually violating contents`);
      } else if (reportedMe >= 2) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} sending sexually violating contents`);
        console.log(`Times reported : ${reportedMe}`);
      }
    } catch (error) {
      console.log(
        `Error in streaming sexuallyExplicitContent : ${error.toString()}`
      );
    }
  });

// inapporiatecontent/imagesofviolencetorture
// imagesofviolencetorture
// only updates
exports.imagesOfViolenceTorture = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Inapporiatecontent/4content/Imagesofviolencetorture/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe === 2) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} image of violence and torture`);
      } else if (reportedMe > 2) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} reason images of violence and torture`);
        console.log(`Times reported : ${reportedMe}`);
      }
    } catch (error) {
      console.log(
        `Error in streaming imagesOfViolenceTorture : ${error.toString()}`
      );
    }
  });

// inapporiatecontent/Hategroup
// Hategroup
// only updates
exports.hateGroup = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Inapporiatecontent/4content/Hategroup/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe >= 3) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} spreading hategroup`);
        console.log(`Times reported : ${reportedMe}`);
      }
    } catch (error) {
      console.log(`Error in streaming Hategroup : ${error.toString()}`);
    }
  });

// inapporiatecontent/Illegalactivityadvertising
// Illegalactivityadvertising
// only updates
exports.illegalActivityAdvertising = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Inapporiatecontent/4content/Illegalactivityadvertising/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe >= 3) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} spreading Illegalactivityadvertising`);
        console.log(`Times reported : ${reportedMe}`);
      }
    } catch (error) {
      console.log(
        `Error in streaming IllegalActivityAdvertising : ${error.toString()}`
      );
    }
  });

// Profileunder18
// only updates
exports.profileUnder18 = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Profileunder18/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe > 10) {
        await updateTrigger.update({
          is_disabled: false,
          is_delete: true,
        });
        await admin.auth().updateUser(uid, { disabled: false }); // revoke disable coz is_delete is tirggered
        console.log(
          `${uid} violated more than 10 triggers.So deleting the account`
        );
      } else if (reportedMe >= 4) {
        await updateTrigger.update({
          is_disabled: true,
        });
        console.log(`${uid} profile is under 18`);
      }
    } catch (error) {
      console.log(`Error in streaming ProfileUnder18 : ${error.toString()}`);
    }
  });

// Hatespeech
// only updates
exports.hateSpeech = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Hatespeech/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe > 10) {
        await updateTrigger.update({
          is_disabled: false,
          is_delete: true,
        });
        await admin.auth().updateUser(uid, { disabled: false }); // revoke disable coz is_delete is tirggered
        console.log(
          `${uid} violated more than 10 triggers.So deleting the account`
        );
      } else if (reportedMe >= 4) {
        await updateTrigger.update({
          is_disabled: true,
        });
        console.log(`${uid} spreading hate speech`);
      }
    } catch (error) {
      console.log(`Error in streaming HateSpeech : ${error.toString()}`);
    }
  });

// Fakelocation
// only updates
exports.fakeLocation = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Fakelocation/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path
      if (reportedMe > 10) {
        await updateTrigger.update({
          is_disabled: false,
          is_delete: true,
        });
        await admin.auth().updateUser(uid, { disabled: false }); // revoke disable coz is_delete is tirggered
        console.log(
          `${uid} violated more than 10 triggers.So deleting the account`
        );
      } else if (reportedMe >= 2) {
        await updateTrigger.update({
          is_disabled: true,
        });
        console.log(`${uid} spoofing fake location`);
      }
    } catch (error) {
      console.log(`Error in streaming FakeLocation : ${error.toString()}`);
    }
  });

// Againstexploredating
// only updates
exports.againstExploreDating = functions
  .region(nearRegion)
  .runWith({ memory: "128MB" })
  .firestore.document(
    "Users/{userId}/Redflags/allredflags/Againstexploredating/docdata"
  )
  .onUpdate(async (change, context) => {
    try {
      const reportedMe = change.after.get("reported_me"); // number of times reported
      const uid = change.after.ref.path.split("/")[1];
      const updateTrigger = admin.firestore().doc(`Users/${uid}`); // trigger path

      if (reportedMe > 6) {
        await updateTrigger.update({
          is_delete: true,
        });
        console.log(`${uid} against explore dating`);
      }
    } catch (error) {
      console.log(
        `Error in streaming AgainstExploreDating : ${error.toString()}`
      );
    }
  });
