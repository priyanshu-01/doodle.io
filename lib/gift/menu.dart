import 'package:flutter/material.dart';

enum currencyType { gems, coins }

const List<Map> reactionsMenu = [
  {
    'name': 'ThumbUp',
    'path': 'assets/reactions/thumbUp.png',
    'currency': currencyType.coins,
    'price': 50,
  },
  {
    'name': 'ThumbDown',
    'path': 'assets/reactions/thumbDown.png',
    'currency': currencyType.coins,
    'price': 50,
  },
  {
    'name': 'Heart',
    'path': 'assets/reactions/heart.png',
    'currency': currencyType.coins,
    'price': 75,
  },
  {
    'name': 'Fire',
    'path': 'assets/reactions/fire.png',
    'currency': currencyType.coins,
    'price': 75,
  },
  {
    'name': 'MiddleFinger',
    'path': 'assets/reactions/middleFinger.png',
    'currency': currencyType.coins,
    'price': 100,
  },
];
