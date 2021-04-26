// todo : all datas of my interests

// * order -> pets , creativity , sports , hangouts , staying in , film & tv , reading , musics ,food & drink , travelling , value & traits

import 'package:explore/icons/profile_my_interests_icons_icons.dart';
import 'package:flutter/material.dart';

class MyInterestsData {
  static List<Map<String, dynamic>> pets = [
    {"icon": ProfileMyInterestsIcons.dog, "name": "Dogs", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.cat,"name": "Cats", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.fish,"name": "Fish", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.birds,"name": "Birds", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.lizard,"name": "Lizards", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.rabbit,"name": "Rabbits", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.snake,"name": "Snakes", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.hamster,"name": "Hamsters", "is_selected": false},
  ];
  static List<Map<String, dynamic>> creativity = [
    {"icon": ProfileMyInterestsIcons.art, "name": "Arts", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.craft, "name": "Crafts", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.dancing, "name": "Dancing", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.design, "name": "Design", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.makeup, "name": "Makeup", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.making_video, "name": "Making videos", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.photography, "name": "Photography", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.singing, "name": "Singing", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.writing, "name": "Writing", "is_selected": false},
  ];
  static List<Map<String, dynamic>> sports = [
    {"icon": ProfileMyInterestsIcons.baseball, "name": "Baseball", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.basket_ball, "name": "Basketball", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.bouldering, "name": "Bouldering", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.boxing, "name": "Boxing", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.soccer, "name": "Football", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.golf, "name": "Golf", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.gym, "name": "Gym", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.gymnastics, "name": "Gymnastics", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.handball, "name": "Handball", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.hockey, "name": "Hockey", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.martial_arts, "name": "Martial arts", "is_selected": false},
    // {"icon": ProfileMyInterestsIcons.dog, "name": "Netball", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.athletics, "name": "Athlectics", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.badmintion, "name": "Badminton", "is_selected": false},
    // {"icon": Icons.nightlife, "name": "Pilates", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.ping_pong, "name": "Ping Pong", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.rowing, "name": "Rowing", "is_selected": false},
    // {"icon":ProfileMyInterestsIcons.dog, "name": "Ruby", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.athletics, "name": "Running", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.skateboarding, "name": "Skateboarding", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.skiing, "name": "Skiing", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.snow_boarding, "name": "Snowboarding", "is_selected": false},
    // {"icon":ProfileMyInterestsIcons.dog, "name": "Soccer", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.yoga, "name": "Meditation", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.surfing, "name": "Surfing", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.swimming, "name": "Swimming", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.tennis, "name": "Tennis", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.volleyball, "name": "Volleyball", "is_selected": false},
    {"icon":ProfileMyInterestsIcons.yoga, "name": "Yoga", "is_selected": false},
  ];
  static List<Map<String, dynamic>> hangouts = [
    {"icon": ProfileMyInterestsIcons.bar, "name": "Bars", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.concerts, "name": "Concerts", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.festivals, "name": "Festivals", "is_selected": false},
    {
      "icon": ProfileMyInterestsIcons.museums_galleries,
      "name": "Museums & \n galleries",
      "is_selected": false
    },
    {"icon": ProfileMyInterestsIcons.night_club, "name": "Nightclubs", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.stand_up, "name": "Standup", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.cinema, "name": "Cinema", "is_selected": false},
  ];
  static List<Map<String, dynamic>> stayingIn = [
    {"icon": ProfileMyInterestsIcons.baking, "name": "Baking", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.board_game, "name": "Board games", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.cooking, "name": "Cooking", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.gardening, "name": "Gardening", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.take_out, "name": "Takeout", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.video_games, "name": "Video games", "is_selected": false},
  ];
  static List<Map<String, dynamic>> filmTv = [
    {
      "icon": ProfileMyInterestsIcons.film_tv,
      "name": "Action & \n adventure",
      "is_selected": false
    },
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Anime", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Animated", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Bollywood", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Comedy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Cooking shows", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Crime", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Documentaries", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Drama", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Fantasy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Game shows", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Horror", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Indie", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Mystery", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Reality shows", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Rom-com", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Romance", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Sci-fi", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Super hero", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.film_tv, "name": "Thriller", "is_selected": false},
  ];
  static List<Map<String, dynamic>> reading = [
    {
      "icon": ProfileMyInterestsIcons.reading,
      "name": "Action & \n adventure",
      "is_selected": false
    },
    {"icon": ProfileMyInterestsIcons.reading, "name": "Biographies", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Classics", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Comedy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Comic books", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Crime", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Fantasy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "History", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Horror", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Manga", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Mystery", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Philosophy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Poetry", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Pschology", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Romance", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Sci-fi", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Science", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.reading, "name": "Thriller", "is_selected": false},
  ];
  static List<Map<String, dynamic>> musics = [
    {"icon": ProfileMyInterestsIcons.music, "name": "Afro", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Arab", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Blues", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Classical", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Country", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Desi", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "EDM", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Funk", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Hip pop", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "House", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Indie", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Jazz", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "K-pop", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Latin", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Metal", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Pop", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Punjabi", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Punk", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "R&b", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Rap", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Reggae", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Rock", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Soul", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Sufi", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.music, "name": "Techno", "is_selected": false},
  ];

  static List<Map<String, dynamic>> foodDrink = [
    {"icon": ProfileMyInterestsIcons.beer, "name": "Beer", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.biryani, "name": "Biryani", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.coffee, "name": "Coffee", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.bar, "name": "Gin", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.noodles_pastas, "name": "Noodles", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.pizza, "name": "Pizza", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.sweet_tooth, "name": "Sweet tooth", "is_selected": false},
     {"icon": ProfileMyInterestsIcons.vegan, "name": "Vegan", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.vegetarain, "name": "Vegetarian", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.whiskey, "name": "Whisky", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.bar, "name": "Wine", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.burger, "name": "Burger", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.noodles_pastas, "name": "Pasta", "is_selected": false},
  ];
  static List<Map<String, dynamic>> travelling = [
    {"icon": ProfileMyInterestsIcons.back_packing, "name": "Backpacking", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.beaches, "name": "Beaches", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.camping, "name": "Camping", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.city_breaks, "name": "City breaks", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.fishing_trips, "name": "Fishing trips", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.hiking_trips, "name": "Hiking trips", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.road_trips, "name": "Road trips", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.spa_weekends, "name": "Spa weekends", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.skiing, "name": "Winter sports", "is_selected": false},
  ];
  static List<Map<String, dynamic>> valueTraits = [
    {"icon": ProfileMyInterestsIcons.ambition, "name": "Ambition", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.being_active, "name": "Being active", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.being_family_oriented, "name": "family oriented", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.being_open_minded,"name": "Being open \n minded","is_selected": false},
    {"icon": ProfileMyInterestsIcons.being_romantic, "name": "Being romantic", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.confidence, "name": "Confidence", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.creativity, "name": "Creativity", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.empathy, "name": "Empathy", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.intelligence, "name": "Intelligence", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.positivity, "name": "Positivity", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.self_awarness, "name": "Self awareness", "is_selected": false},
    {
      "icon": ProfileMyInterestsIcons.sense_of_adventure,
      "name": "Sense of \n adventure",
      "is_selected": false
    },
    {"icon": ProfileMyInterestsIcons.sense_of_humor, "name": "Sense of humor", "is_selected": false},
    {"icon": ProfileMyInterestsIcons.social_awarness, "name": "Social \n awareness", "is_selected": false},
  ];
}

int timesInterestsClicked = 0;