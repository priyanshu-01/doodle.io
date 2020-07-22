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
    'name': 'SmileFace',
    'image': const Image(
      image: AssetImage('assets/reactions/smileFace.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'explodingHead',
    'image': const Image(
      image: AssetImage('assets/reactions/explodingHead.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'faceBlowingAKiss',
    'image': const Image(
      image: AssetImage('assets/reactions/faceBlowingAKiss.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'kissMark',
    'image': const Image(
      image: AssetImage('assets/reactions/kissMark.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'lightBulb',
    'image': const Image(
      image: AssetImage('assets/reactions/lightBulb.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'pileOfPoo',
    'image': const Image(
      image: AssetImage('assets/reactions/pileOfPoo.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'smilingFaceWithHeartEyes',
    'image': const Image(
      image: AssetImage('assets/reactions/smilingFaceWithHeartEyes.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'starStruck',
    'image': const Image(
      image: AssetImage('assets/reactions/starStruck.png'),
    ),
    'currency': currencyType.coins,
    'price': 20,
  },
  {
    'name': 'thinkingFace',
    'image': const Image(
      image: AssetImage('assets/reactions/thinkingFace.png'),
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
