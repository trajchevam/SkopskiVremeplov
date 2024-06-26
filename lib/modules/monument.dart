import 'package:camera/camera.dart';

import 'location.dart';

class Monument {
  int id;
  String name;
  Location location;
  String description;
  String img;

  Monument(this.id, this.name, this.location, this.description, this.img);

  static List<Monument> getMonuments() {
    return [
      Monument(1, "Камен мост", Location.location1, "Description", 'https://macedonia-timeless.com/wp-content/uploads/2018/09/kamen-most-1.jpg'),
      Monument(2, "Кале", Location.location2, "Камениот мост во Скопје — една од најзначајните знаменитости на градот. Сместен е во центарот на градот и ги поврзува плоштадот Македонија и Старата скопска чаршија. Постојат две претпоставки околу датацијата на мостот. Според првата која е потврдена со археолошките проучувања, тој бил изграден во VI век, веднаш по катастрофалниот земјотрес од 518 г., во текот на градежните активности кои биле преземени низ сета Империја од страна на императорот Јустинијан I. Според втората претпоставка, која е поддржана со историски извори, мостот бил изграден во времето на султанот Мехмед II Освојувачот (1444-1446; 1451-1481), во периодот меѓу 1451 и 1469 г. Мостот денеска се смета за симбол на градот Скопје и е главен елемент на грбот на Скопје, кој пак грб е насликан на знамето на Скопје во жолто-златна боја.", ""),
      Monument(3, "Стара чаршија", Location.location3, "Стара скопска чаршија — трговски и културно-историски дел во Скопје и една од најголемите знаменитости на градот. Се наоѓа на просторот од Камениот мост до Бит-пазар и од Калето до реката Серава. Според административната поделба на градот, просторот на чаршијата се наоѓа на подрачјето на општините Чаир и Центар.", ''),
      Monument(4, "Плоштад Македонија", Location.location4, "Плоштад „Македонија“ — главниот плоштад на градот Скопје, престолнината на Македонија. Изграден е во периодот помеѓу 1920 и 1940 година. Урбанистички, на него се наоѓале поголем број значајни објекти како: Народната банка со мермерни фасади, монументалниот Офицерски дом, Ристиќевата палата, Палатата „Мазура“ итн.", ''),
      Monument(5, "Градски парк", Location.location5, "Градски парк — јавен парк во Скопје и најголемиот градски парк во земјата. Почнал да се формира некаде во XIX век. Културата на уредување на градини и одгледување цвеќе кај Македонците е стара колку и нивното постоење, но зелени површини од јавен карактер во Скопје се јавуват дури кон крајот на XIX и почетокот на XX век, од кога и датираат првите податоци за градскиот парк.", ''),
      Monument(6, "Матка", Location.location6, "Матка — кањон на реката Треска, десна притока на Вардар, зафаќа површина од околу 5.000 хектари и се наоѓа на 17 километри југозападно од Скопје. Според морфогенетските одлики претставува клисура-пробојница. На овој простор посебно внимание заслужуваат карстните облици — десетте пештери со должина од 20 до 176 метри и двата пропасти со длабочина до 35 метри.", 'https://upload.wikimedia.org/wikipedia/commons/8/80/Matka_Canyon_Skopje_3.jpg'),
      Monument(7, "Милениумски крст", Location.location7, "Милениумскиот крст се наоѓа на врвот Крстовар на планината Водно, непосредно над градот Скопје. Изграден е во 2002 год. Со 66 м височина, тој е еден од највисоките градби во Македонија. Неговите архитекти се Јован Стефановски-Жан и Оливер Петровски. Изграден е во чест на две илјади години христијанство во Македонија и доаѓањето на новиот милениум.", ''),
    ];
  }

  static Monument monument1 = Monument.getMonuments()[0];
  static Monument monument2 = Monument.getMonuments()[1];
  static Monument monument3 = Monument.getMonuments()[2];
  static Monument monument4 = Monument.getMonuments()[3];
  static Monument monument5 = Monument.getMonuments()[4];
  static Monument monument6 = Monument.getMonuments()[5];
  static Monument monument7 = Monument.getMonuments()[6];


  }