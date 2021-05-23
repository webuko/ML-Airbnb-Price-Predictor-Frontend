class Host {
  final String name;
  final String image;
  final String desc;
  final String price;
  final String rating;

  Host(
      {required this.name,
      required this.image,
      required this.desc,
      required this.price,
      required this.rating});
}

class GeneralModelList {
  final List<Host> host;

  GeneralModelList({required this.host});
}

final GeneralModelList categoryList = new GeneralModelList(
  host: [
    Host(
        name: "Enter House -8 beds",
        desc: "Miamo-Amazing view in Imerolivi",
        image: "assets/images/house2.jpeg",
        price: "\$1800 per night",
        rating: "984"),
    Host(
        name: "classic American",
        desc: "The Curious Palace Town",
        image: "assets/images/house3.jpeg",
        price: "About \$30 per person",
        rating: "688"),
    Host(
        name: "Miamo-Amazing view in Imerolivi",
        desc: "The Curious Palace Town",
        image: "assets/images/house1.jpg",
        price: "\$1300 per night",
        rating: "900"),
  ],
);
