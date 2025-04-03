class SosmedModel {
  String sosmed;
  String linkPath;
  String iconPath;

  SosmedModel(
      {required this.sosmed, required this.linkPath, required this.iconPath});

  static List<SosmedModel> getSosmeds() {
    List<SosmedModel> sosmeds = [];

    sosmeds.add(SosmedModel(
        sosmed: 'Instagram',
        linkPath: 'https://www.instagram.com/rizki.sepriadi',
        iconPath: 'assets/icons/instagram.svg'));
    sosmeds.add(SosmedModel(
        sosmed: 'Github',
        linkPath: 'https://github.com/rizkisepriadi',
        iconPath: 'assets/icons/github.svg'));
    sosmeds.add(SosmedModel(
        sosmed: 'LinkedIn',
        linkPath: 'https://linkedin.com/in/rizkisepriadi',
        iconPath: 'assets/icons/linkedin.svg'));

    return sosmeds;
  }
}
