import 'package:flutter/material.dart';

IconData getIconFromString(String iconName) {
  switch (iconName) {
    case "Icon.brush":
      return Icons.brush;
    case "Icon.local_hospital":
      return Icons.local_hospital;
    case "Icon.grass":
      return Icons.grass;
    case "Icon.electrical_services":
      return Icons.electrical_services;
    case "Icon.build":
      return Icons.build;
    case "Icon.construction":
      return Icons.construction;
    case "Icon.chair":
      return Icons.chair;
    case "Icon.dry_cleaning":
      return Icons.dry_cleaning;
    case "Icon.account_balance":
      return Icons.account_balance;
    case "Icon.videocam":
      return Icons.videocam;
    case "Icon.fitness_center":
      return Icons.fitness_center;
    case "Icon.cleaning_services":
      return Icons.cleaning_services;
    case "Icon.person":
      return Icons.person;
    case "Icon.school":
      return Icons.school;
    case "Icon.restaurant":
      return Icons.restaurant;
    case "Icon.phone_iphone":
      return Icons.phone_iphone;
    case "Icon.device_thermostat":
      return Icons.device_thermostat;
    case "Icon.computer":
      return Icons.computer;
    case "Icon.car_repair":
      return Icons.car_repair;
    case "Icon.pedal_bike":
      return Icons.pedal_bike;
    case "Icon.two_wheeler":
      return Icons.two_wheeler;
    case "Icon.local_grocery_store":
      return Icons.local_grocery_store;
    case "Icon.fastfood":
      return Icons.fastfood;
    case "Icon.transfer_within_a_station":
      return Icons.transfer_within_a_station;
    case "Icon.local_laundry_service":
      return Icons.local_laundry_service;
    case "Icon.local_shipping":
      return Icons.local_shipping;
    default:
      return Icons.help_outline;
  }
}
