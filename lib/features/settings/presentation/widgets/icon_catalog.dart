import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/feather.dart';
import 'package:iconify_flutter/icons/fa_solid.dart';
import 'package:iconify_flutter/icons/heroicons_outline.dart';
import 'package:iconify_flutter/icons/heroicons_solid.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/tabler.dart';

typedef AppIconBuilder = Widget Function({
  required Color color,
  required double size,
});

class AppIconCatalog {
  static const allPackId = 'all';
  static const materialPackId = 'material';
  static const remixPackId = 'remix';
  static const tablerPackId = 'tabler';
  static const phosphorPackId = 'phosphor';
  static const heroiconsOutlinePackId = 'heroicons_outline';
  static const heroiconsSolidPackId = 'heroicons_solid';
  static const featherPackId = 'feather';
  static const fontAwesomeSolidPackId = 'font_awesome_solid';

  static const _packLabels = <String, String>{
    allPackId: 'All',
    materialPackId: 'Material',
    remixPackId: 'Remix',
    tablerPackId: 'Tabler',
    phosphorPackId: 'Phosphor',
    heroiconsOutlinePackId: 'Heroicons Outlined',
    heroiconsSolidPackId: 'Heroicons Solid',
    featherPackId: 'Feather',
    fontAwesomeSolidPackId: 'Font Awesome',
  };

  static final List<IconPack> packs = [
    const IconPack(id: allPackId, label: 'All'),
    const IconPack(id: materialPackId, label: 'Material'),
    const IconPack(id: remixPackId, label: 'Remix'),
    const IconPack(id: tablerPackId, label: 'Tabler'),
    const IconPack(id: phosphorPackId, label: 'Phosphor'),
    const IconPack(id: heroiconsOutlinePackId, label: 'Heroicons Outlined'),
    const IconPack(id: heroiconsSolidPackId, label: 'Heroicons Solid'),
    const IconPack(id: featherPackId, label: 'Feather'),
    const IconPack(id: fontAwesomeSolidPackId, label: 'Font Awesome'),
  ];

  static final List<AppIconOption> options = [
    // Material
    _material('home', Icons.home, aliases: ['house', 'dashboard']),
    _material('wallet', Icons.wallet, aliases: ['money', 'cash']),
    _material('credit_card', Icons.credit_card, aliases: ['card', 'payment']),
    _material('payments', Icons.payments, aliases: ['pay']),
    _material('savings', Icons.savings, aliases: ['save', 'bank']),
    _material('shopping_bag', Icons.shopping_bag, aliases: ['shop', 'store']),
    _material('shopping_cart', Icons.shopping_cart, aliases: ['cart', 'buy']),
    _material('receipt_long', Icons.receipt_long, aliases: ['receipt', 'invoice']),
    _material('restaurant', Icons.restaurant, aliases: ['food', 'dining']),
    _material('flight', Icons.flight, aliases: ['travel', 'airplane']),
    _material('directions_car', Icons.directions_car, aliases: ['car', 'vehicle']),
    _material('local_shipping', Icons.local_shipping, aliases: ['truck', 'delivery']),
    _material('work', Icons.work, aliases: ['briefcase', 'office']),
    _material('school', Icons.school, aliases: ['education', 'study']),
    _material('settings', Icons.settings, aliases: ['gear']),
    _material('health_and_safety', Icons.health_and_safety, aliases: ['health', 'medical']),
    _material('camera', Icons.camera, aliases: ['photo']),
    _material('phone', Icons.phone, aliases: ['call', 'mobile']),
    _material('gift', Icons.card_giftcard, aliases: ['present', 'gift']),
    _material('calendar_month', Icons.calendar_month, aliases: ['date', 'schedule']),
    _material('more_time', Icons.more_time, aliases: ['clock', 'time']),
    _material('bolt', Icons.bolt, aliases: ['energy', 'electric']),
    _material('wifi', Icons.wifi, aliases: ['internet', 'connection']),
    _material('devices', Icons.devices, aliases: ['laptop', 'computer']),
    _material('lunch_dining', Icons.lunch_dining, aliases: ['meal']),
    _material('coffee', Icons.coffee, aliases: ['drink']),
    _material('icecream', Icons.icecream, aliases: ['dessert']),
    _material('bakery_dining', Icons.bakery_dining, aliases: ['cake', 'bread']),
    _material('liquor', Icons.liquor, aliases: ['bar', 'drink']),
    _material('fastfood', Icons.fastfood, aliases: ['burger', 'snack']),
    _material('kitchen', Icons.kitchen, aliases: ['home', 'cook']),
    _material('local_bar', Icons.local_bar, aliases: ['bar']),
    _material('local_taxi', Icons.local_taxi, aliases: ['taxi']),
    _material('checkroom', Icons.checkroom, aliases: ['clothes']),
    _material('more_horiz', Icons.more_horiz, aliases: ['more']),
    // Remix
    _remix('bank_fill', Ri.bank_fill, aliases: ['bank', 'finance']),
    _remix('bank_card_fill', Ri.bank_card_fill, aliases: ['card', 'payment']),
    _remix('calendar_fill', Ri.calendar_fill, aliases: ['date', 'schedule']),
    _remix('camera_fill', Ri.camera_fill, aliases: ['photo']),
    _remix('car_fill', Ri.car_fill, aliases: ['vehicle']),
    _remix('gift_fill', Ri.gift_fill, aliases: ['present']),
    _remix('home_fill', Ri.home_fill, aliases: ['house']),
    _remix('phone_fill', Ri.phone_fill, aliases: ['call']),
    _remix('settings_fill', Ri.settings_fill, aliases: ['gear']),
    _remix('shopping_bag_fill', Ri.shopping_bag_fill, aliases: ['shop']),
    _remix('shopping_cart_fill', Ri.shopping_cart_fill, aliases: ['cart']),
    _remix('truck_fill', Ri.truck_fill, aliases: ['delivery']),
    _remix('wallet_fill', Ri.wallet_fill, aliases: ['money']),
    _remix('bill_fill', Ri.bill_fill, aliases: ['receipt', 'invoice']),
    _remix('bank_card_line', Ri.bank_card_line, aliases: ['card', 'payment']),
    _remix('flight_takeoff_fill', Ri.flight_takeoff_fill, aliases: ['travel', 'airplane']),
    // Tabler
    _tabler('calendar', Tabler.calendar, aliases: ['date', 'schedule']),
    _tabler('camera', Tabler.camera, aliases: ['photo']),
    _tabler('car', Tabler.car, aliases: ['vehicle']),
    _tabler('credit_card', Tabler.credit_card, aliases: ['card', 'payment']),
    _tabler('gift', Tabler.gift, aliases: ['present']),
    _tabler('home', Tabler.home, aliases: ['house']),
    _tabler('phone', Tabler.phone, aliases: ['call']),
    _tabler('receipt', Tabler.receipt, aliases: ['invoice']),
    _tabler('shopping_cart', Tabler.shopping_cart, aliases: ['cart']),
    _tabler('truck', Tabler.truck, aliases: ['delivery']),
    _tabler('wallet', Tabler.wallet, aliases: ['money']),
    _tabler('settings', Tabler.settings, aliases: ['gear']),
    // Phosphor
    _phosphor('bank', Ph.bank, aliases: ['bank', 'finance']),
    _phosphor('calendar', Ph.calendar, aliases: ['date']),
    _phosphor('camera', Ph.camera, aliases: ['photo']),
    _phosphor('car', Ph.car, aliases: ['vehicle']),
    _phosphor('credit_card', Ph.credit_card, aliases: ['card', 'payment']),
    _phosphor('gift', Ph.gift, aliases: ['present']),
    _phosphor('phone', Ph.phone, aliases: ['call']),
    _phosphor('receipt', Ph.receipt, aliases: ['invoice']),
    _phosphor('shopping_bag', Ph.shopping_bag, aliases: ['shop']),
    _phosphor('shopping_cart', Ph.shopping_cart, aliases: ['cart']),
    _phosphor('truck', Ph.truck, aliases: ['delivery']),
    _phosphor('wallet', Ph.wallet, aliases: ['money']),
    // Heroicons outlined
    _heroOutline('banknotes', HeroiconsOutline.banknotes, aliases: ['cash']),
    _heroOutline('calendar', HeroiconsOutline.calendar, aliases: ['date']),
    _heroOutline('camera', HeroiconsOutline.camera, aliases: ['photo']),
    _heroOutline('credit_card', HeroiconsOutline.credit_card, aliases: ['card', 'payment']),
    _heroOutline('gift', HeroiconsOutline.gift, aliases: ['present']),
    _heroOutline('home', HeroiconsOutline.home, aliases: ['house']),
    _heroOutline('phone', HeroiconsOutline.phone, aliases: ['call']),
    _heroOutline('receipt_percent', HeroiconsOutline.receipt_percent, aliases: ['receipt', 'discount']),
    _heroOutline('receipt_refund', HeroiconsOutline.receipt_refund, aliases: ['invoice']),
    _heroOutline('shopping_bag', HeroiconsOutline.shopping_bag, aliases: ['shop']),
    _heroOutline('shopping_cart', HeroiconsOutline.shopping_cart, aliases: ['cart']),
    _heroOutline('truck', HeroiconsOutline.truck, aliases: ['delivery']),
    // Heroicons solid
    _heroSolid('banknotes', HeroiconsSolid.banknotes, aliases: ['cash']),
    _heroSolid('calendar', HeroiconsSolid.calendar, aliases: ['date']),
    _heroSolid('camera', HeroiconsSolid.camera, aliases: ['photo']),
    _heroSolid('credit_card', HeroiconsSolid.credit_card, aliases: ['card', 'payment']),
    _heroSolid('gift', HeroiconsSolid.gift, aliases: ['present']),
    _heroSolid('home', HeroiconsSolid.home, aliases: ['house']),
    _heroSolid('phone', HeroiconsSolid.phone, aliases: ['call']),
    _heroSolid('shopping_bag', HeroiconsSolid.shopping_bag, aliases: ['shop']),
    _heroSolid('shopping_cart', HeroiconsSolid.shopping_cart, aliases: ['cart']),
    _heroSolid('truck', HeroiconsSolid.truck, aliases: ['delivery']),
    // Feather
    _feather('calendar', Feather.calendar, aliases: ['date']),
    _feather('camera', Feather.camera, aliases: ['photo']),
    _feather('credit_card', Feather.credit_card, aliases: ['card', 'payment']),
    _feather('gift', Feather.gift, aliases: ['present']),
    _feather('home', Feather.home, aliases: ['house']),
    _feather('phone', Feather.phone, aliases: ['call']),
    _feather('shopping_bag', Feather.shopping_bag, aliases: ['shop']),
    _feather('truck', Feather.truck, aliases: ['delivery']),
    // Font Awesome solid
    _fontAwesome('home', FaSolid.home, aliases: ['house']),
    _fontAwesome('wallet', FaSolid.wallet, aliases: ['money', 'cash']),
    _fontAwesome('credit_card', FaSolid.credit_card, aliases: ['card', 'payment']),
    _fontAwesome('receipt', FaSolid.receipt, aliases: ['invoice']),
    _fontAwesome('shopping_bag', FaSolid.shopping_bag, aliases: ['shop']),
    _fontAwesome('shopping_cart', FaSolid.shopping_cart, aliases: ['cart']),
    _fontAwesome('truck', FaSolid.truck, aliases: ['delivery']),
    _fontAwesome('calendar', FaSolid.calendar, aliases: ['date', 'schedule']),
    _fontAwesome('camera', FaSolid.camera, aliases: ['photo']),
    _fontAwesome('car', FaSolid.car, aliases: ['vehicle']),
    _fontAwesome('gift', FaSolid.gift, aliases: ['present']),
    _fontAwesome('phone', FaSolid.phone, aliases: ['call']),
    _fontAwesome('money_bill', FaSolid.money_bill, aliases: ['cash']),
    _fontAwesome('money_check', FaSolid.money_check, aliases: ['cash', 'payment']),
  ];

  static Widget render(
    String iconKey, {
    required Color color,
    required double size,
  }) {
    final option = optionForKey(iconKey);
    if (option == null) {
      return Icon(Icons.help_outline, size: size, color: color);
    }
    return option.build(color: color, size: size);
  }

  static AppIconOption? optionForKey(String key) {
    final normalizedKey = normalizeKey(key);
    for (final option in options) {
      if (option.storageKey == normalizedKey || option.legacyKey == normalizedKey) {
        return option;
      }
    }
    return null;
  }

  static List<AppIconOption> filter({
    required String packId,
    required String query,
  }) {
    final normalizedQuery = _normalize(query);
    return options.where((option) {
      final matchesPack = packId == allPackId || option.packId == packId;
      if (!matchesPack) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }
      return option.searchIndex.contains(normalizedQuery);
    }).toList(growable: false);
  }

  static String packLabel(String packId) {
    return _packLabels[packId] ?? packId;
  }

  static String normalizeKey(String key) {
    if (key.contains(':')) {
      return key;
    }
    return '$materialPackId:$key';
  }

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static AppIconOption _material(
    String name,
    IconData icon, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: materialPackId,
      packLabel: packLabel(materialPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Icon(icon, color: color, size: size),
    );
  }

  static AppIconOption _remix(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: remixPackId,
      packLabel: packLabel(remixPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _tabler(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: tablerPackId,
      packLabel: packLabel(tablerPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _phosphor(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: phosphorPackId,
      packLabel: packLabel(phosphorPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _heroOutline(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: heroiconsOutlinePackId,
      packLabel: packLabel(heroiconsOutlinePackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _heroSolid(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: heroiconsSolidPackId,
      packLabel: packLabel(heroiconsSolidPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _feather(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: featherPackId,
      packLabel: packLabel(featherPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }

  static AppIconOption _fontAwesome(
    String name,
    String svg, {
    List<String> aliases = const [],
  }) {
    return AppIconOption(
      packId: fontAwesomeSolidPackId,
      packLabel: packLabel(fontAwesomeSolidPackId),
      iconName: name,
      aliases: aliases,
      build: ({required color, required size}) => Iconify(
        svg,
        color: color,
        size: size,
      ),
    );
  }
}

class IconPack {
  const IconPack({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class AppIconOption {
  const AppIconOption({
    required this.packId,
    required this.packLabel,
    required this.iconName,
    required this.build,
    this.aliases = const [],
  });

  final String packId;
  final String packLabel;
  final String iconName;
  final List<String> aliases;
  final AppIconBuilder build;

  String get storageKey => '$packId:$iconName';
  String get legacyKey => iconName;

  String get searchIndex {
    final tokens = <String>[
      packLabel,
      iconName,
      iconName.replaceAll('_', ' '),
      ...aliases,
    ];
    return AppIconCatalog._normalize(tokens.join(' '));
  }
}
