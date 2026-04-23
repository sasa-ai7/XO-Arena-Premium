class GameAvatar {
  final int id;
  final String name;
  final String assetPath;
  final int price;
  final bool isGif;
  final double previewScale;
  final double frameScale;
  final double verticalOffset;
  final double innerCircleScale;

  const GameAvatar({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
    required this.isGif,
    this.previewScale = 0.86,
    this.frameScale = 1.06,
    this.verticalOffset = 0.0,
    this.innerCircleScale = 1.08,
  });
}

const List<GameAvatar> kGameAvatars = [
  GameAvatar(id: 1, name: 'Classic', assetPath: 'assets/avatar/Avatar__1.png', price: 0, isGif: false),
  GameAvatar(id: 2, name: 'Echo', assetPath: 'assets/avatar/Avatar_2.png', price: 600, isGif: false),
  GameAvatar(id: 3, name: 'Titan', assetPath: 'assets/avatar/Avatar__3.png', price: 3000, isGif: false),
  GameAvatar(id: 4, name: 'Frost', assetPath: 'assets/avatar/Avatar__4.png', price: 1000, isGif: false),
  GameAvatar(id: 5, name: 'Storm', assetPath: 'assets/avatar/Avatar__5.png', price: 1200, isGif: false),
  GameAvatar(id: 6, name: 'Phantom', assetPath: 'assets/avatar/Avatar__6.png', price: 1000, isGif: false),
  GameAvatar(id: 7, name: 'Inferno', assetPath: 'assets/avatar/Avatar__7.gif', price: 2500, isGif: true, previewScale: 0.66, frameScale: 1.10, verticalOffset: 0.04, innerCircleScale: 1.16),
  GameAvatar(id: 8, name: 'Celestial', assetPath: 'assets/avatar/Avatar__8.gif', price: 2500, isGif: true, previewScale: 0.67, frameScale: 1.10, verticalOffset: 0.03, innerCircleScale: 1.15),
  GameAvatar(id: 9, name: 'Eclipse', assetPath: 'assets/avatar/Avatar__9.png', price: 2000, isGif: false),
  GameAvatar(id: 10, name: 'Apex', assetPath: 'assets/avatar/Avatar__10.gif', price: 2500, isGif: true, previewScale: 0.66, frameScale: 1.10, verticalOffset: 0.05, innerCircleScale: 1.18),
];

GameAvatar gameAvatarById(int id) {
  return kGameAvatars.firstWhere(
    (a) => a.id == id,
    orElse: () => kGameAvatars.first,
  );
}
