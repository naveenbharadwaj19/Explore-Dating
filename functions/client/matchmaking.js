// todo create matchmaking datas

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const nearRegion = "asia-south1";
const { loadImage, createCanvas } = require("canvas");
const { encode } = require("blurhash");

exports.createMatchMakingData = functions
  .runWith({ memory: "256MB", timeoutSeconds: 100 })
  .https.onCall(async (data, context) => {
    // output -> 200 ok 1 -> head,body,hash completed
    // output -> 200 ok 2 -> head,body url exists and processing without hash
    // output -> 200 ok 3 -> no head,body,hash found.processing without images
    var headPhoto = data.headPhoto;
    var bodyPhoto = data.bodyPhoto;
    var selectedShowMe = data.selectedShowMe;
    var uid = context.auth.uid;

    var headPhotoHash = "";
    var bodyPhotoHash = "";
    var homo = false;
    var fireStore = admin.firestore();
    var fetchUserData = await fireStore.doc(`Users/${uid}`).get();
    // check if user is homo
    if (selectedShowMe === fetchUserData.get("bio.gender").toString()) {
      homo = true;
    }
    var createMatchMakingDoc = fireStore.collection(
      `Matchmaking/simplematch/MenWomen`
    );
    headPhotoHash = await blurHashImageUrl(headPhoto);
    bodyPhotoHash = await blurHashImageUrl(bodyPhoto);
    if (
      !headPhotoHash.includes("Cannot hash image") &&
      !bodyPhotoHash.includes("Cannot hash image") &&
      !headPhoto.includes("Cannot get image url") &&
      !bodyPhoto.includes("Cannot get image url")
    ) {
      // create matchmaking doc
      await createMatchMakingDoc.add({
        uid: uid,
        show_me: selectedShowMe,
        age: fetchUserData.get("bio.age"),
        gender: fetchUserData.get("bio.gender"),
        name: fetchUserData.get("bio.name"),
        geohash_rounds: {
          rh: homo,
        },
        photos: {
          current_head_photo: headPhoto,
          current_head_photo_hash: headPhotoHash,
          current_body_photo: bodyPhoto,
          current_body_photo_hash: bodyPhotoHash,
        },
      });
      storeProfileData(
        fetchUserData.get("bio.name"),
        uid,
        fetchUserData.get("bio.age"),
        headPhoto,
        headPhotoHash
      );
      storeProfilePhotosInfo(uid, bodyPhotoHash, bodyPhoto);
      console.log("200 ok 1");
    } else {
      console.log(
        "Something went wrong.First trying if head and body url exists in else statement"
      );
      // if head and body photo url exists
      if (
        !headPhoto.includes("Cannot get image url") &&
        !bodyPhoto.includes("Cannot get image url")
      ) {
        console.log("Found head and body url.Processing without hash...");
        // create matchmaking doc
        await createMatchMakingDoc.add({
          uid: uid,
          show_me: selectedShowMe,
          age: fetchUserData.get("bio.age"),
          gender: fetchUserData.get("bio.gender"),
          name: fetchUserData.get("bio.name"),
          geohash_rounds: {
            rh: homo,
          },
          photos: {
            current_head_photo: "Cannot get image url",
            current_body_photo: "Cannot get image url",
          },
        });
        storeProfileData(
          fetchUserData.get("bio.name"),
          uid,
          fetchUserData.get("bio.age"),
          "",
          ""
        );
        storeProfilePhotosInfo(uid, "", "");
        console.log("200 ok 2");
      } else {
        console.log("No head,body url exists & No hash found");
        // create matchmaking doc
        await createMatchMakingDoc.add({
          uid: uid,
          show_me: selectedShowMe,
          age: fetchUserData.get("bio.age"),
          gender: fetchUserData.get("bio.gender"),
          name: fetchUserData.get("bio.name"),
          geohash_rounds: {
            rh: homo,
          },
          photos: {
            current_head_photo: "Cannot get image url",
            current_body_photo: "Cannot get image url",
          },
        });
        storeProfileData(
          fetchUserData.get("bio.name"),
          uid,
          fetchUserData.get("bio.age"),
          "",
          ""
        );
        storeProfilePhotosInfo(uid, "", "");
        console.log("200 ok 3");
      }
    }
    return 200;
  });

// blur hash image url
async function blurHashImageUrl(imageUrl) {
  try {
    const getImageData = (image) => {
      const canvas = createCanvas(image.width, image.height, "jpg");
      const context = canvas.getContext("2d");
      context.drawImage(image, 0, 0);
      return context.getImageData(0, 0, image.width, image.height);
    };
    const image = await loadImage(imageUrl);
    const imageData = getImageData(image);
    const hash = encode(
      imageData.data,
      imageData.width,
      imageData.height,
      4,
      3
    );
    return hash;
  } catch (error) {
    console.log(`Error in hasing image url : ${error.toString()}`);
    return "Cannot hash image";
  }
}
/**
 * @param  {string} name
 * @param  {string} uid
 * @param  {number} age
 * @param  {string} headPhotoUrl
 * @param  {string} headPhotoHash
 */
async function storeProfileData(name, uid, age, headPhotoUrl, headPhotoHash) {
  try {
    var data = admin.firestore().doc(`Users/${uid}/Profile/profile`);
    await data.set({
      name: name,
      age: age,
      location: {
        city: "",
        state: "",
      }, // location will be updated later
      head_photo: { hash: headPhotoHash, url: headPhotoUrl },
      about_me: "",
      my_interests: [],
      education_level: "",
      education: "",
      work: "",
      exercise: "",
      height: "",
      smoking: "",
      drinking: "",
      looking_for: "",
      kids: "",
      from: {
        country: "",
        state: "",
        city: "",
      },
      zodiac_signs: "",
      do_not_show_again: false,
      show_photos_info: true,
    });
    // total 19 fields
    console.log("Profile data stored successfully");
  } catch (error) {
    console.log(`Error in storing profile data : ${error.toString()}`);
  }
}
/**
 * @param  {string} uid
 * @param  {string} bodyPhotoHash
 * @param  {string} bodyPhotoUrl
 */
async function storeProfilePhotosInfo(uid, bodyPhotoHash, bodyPhotoUrl) {
  try {
    var data = admin
      .firestore()
      .doc(`Users/${uid}/Profile/profile/Photos/myphotos`);
    await data.set({
      show_on_feeds: {
        hash: bodyPhotoHash,
        url: bodyPhotoUrl,
      },
      photos: [
        {
          hash: bodyPhotoHash,
          url: bodyPhotoUrl,
        },
      ],
      total_photos_uploaded: 1,
      time_feed_icon_clicked: admin.firestore.FieldValue.serverTimestamp(), // latest time feed icon clicked
      time_photo_uploaded: admin.firestore.FieldValue.serverTimestamp(), // latest time new photo uploaded
    });
    console.log("Photos data stored successfully");
  } catch (error) {
    console.log(`Error in storing photos data : ${error.toString()}`);
  }
}
