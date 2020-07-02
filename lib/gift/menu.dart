import 'package:flutter/material.dart';

enum currencyType { gems, coins }

const List<Map> reactionsMenu = [
  {
    'name': 'ThumbUp',
    'image': const Image(
      image: AssetImage('assets/reactions/thumbUp.png'),
    ),
    'currency': currencyType.coins,
    'price': 10,
  },
  {
    'name': 'ThumbDown',
    'image': const Image(
      image: AssetImage('assets/reactions/thumbDown.png'),
    ),
    'currency': currencyType.coins,
    'price': 10,
  },
  {
    'name': 'Heart',
    'image': const Image(
      image: AssetImage('assets/reactions/heart.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'Fire',
    'image': const Image(
      image: AssetImage('assets/reactions/fire.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'MiddleFinger',
    'image': const Image(
      image: AssetImage('assets/reactions/middleFinger.png'),
    ),
    'currency': currencyType.coins,
    'price': 50,
  },
];
