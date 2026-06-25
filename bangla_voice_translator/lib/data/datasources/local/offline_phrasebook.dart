class OfflinePhrasebook {
  static const List<Map<String, String>> phrases = [
    // Greetings
    {'bn': 'হ্যালো', 'ko': '안녕하세요', 'en': 'Hello'},
    {'bn': 'শুভ সকাল', 'ko': '좋은 아침이에요', 'en': 'Good morning'},
    {'bn': 'শুভ রাত্রি', 'ko': '안녕히 주무세요', 'en': 'Good night'},
    {'bn': 'আপনি কেমন আছেন?', 'ko': '어떻게 지내세요?', 'en': 'How are you?'},
    {'bn': 'আমি ভালো আছি', 'ko': '잘 지내고 있어요', 'en': 'I am fine'},
    {'bn': 'ধন্যবাদ', 'ko': '감사합니다', 'en': 'Thank you'},
    {'bn': 'দয়া করে', 'ko': '부탁합니다', 'en': 'Please'},
    {'bn': 'দুঃখিত', 'ko': '죄송합니다', 'en': 'Sorry'},
    {'bn': 'হ্যাঁ', 'ko': '네', 'en': 'Yes'},
    {'bn': 'না', 'ko': '아니요', 'en': 'No'},

    // Common phrases
    {'bn': 'আমি বাংলায় কথা বলি', 'ko': '저는 벵골어를 합니다', 'en': 'I speak Bangla'},
    {'bn': 'আপনি কি ইংরেজি বলেন?', 'ko': '영어를 할 수 있나요?', 'en': 'Do you speak English?'},
    {'bn': 'আমি বুঝতে পারছি না', 'ko': '이해하지 못하겠어요', 'en': 'I don\'t understand'},
    {'bn': 'আবার বলুন', 'ko': '다시 말해주세요', 'en': 'Please say it again'},
    {'bn': 'এটা কত?', 'ko': '얼마에요?', 'en': 'How much is this?'},
    {'bn': 'আমার নাম...', 'ko': '제 이름은...', 'en': 'My name is...'},
    {'bn': 'আমি বাংলাদেশ থেকে এসেছি', 'ko': '저는 방글라데시에서 왔어요', 'en': 'I am from Bangladesh'},
    {'bn': 'আপনার সাথে দেখা করে ভালো লাগলো', 'ko': '만나서 반갑습니다', 'en': 'Nice to meet you'},
    {'bn': 'বিদায়', 'ko': '안녕히 가세요', 'en': 'Goodbye'},
    {'bn': 'সাহায্য করুন', 'ko': '도와주세요', 'en': 'Help me'},

    // Travel
    {'bn': 'বিমানবন্দর কোথায়?', 'ko': '공항은 어디에 있나요?', 'en': 'Where is the airport?'},
    {'bn': 'হোটেল কোথায়?', 'ko': '호텔은 어디에 있나요?', 'en': 'Where is the hotel?'},
    {'bn': 'টয়লেট কোথায়?', 'ko': '화장실은 어디에 있나요?', 'en': 'Where is the toilet?'},
    {'bn': 'আমি হারিয়ে গেছি', 'ko': '길을 잃었어요', 'en': 'I am lost'},
    {'bn': 'ট্যাক্সি ডাকুন', 'ko': '택시를 불러주세요', 'en': 'Call a taxi'},

    // Food
    {'bn': 'আমি ক্ষুধার্ত', 'ko': '배고파요', 'en': 'I am hungry'},
    {'bn': 'আমি তৃষ্ণার্ত', 'ko': '목마르다', 'en': 'I am thirsty'},
    {'bn': 'মেনু দিন', 'ko': '메뉴 주세요', 'en': 'Give me the menu'},
    {'bn': 'বিল দিন', 'ko': '계산서 주세요', 'en': 'Give me the bill'},
    {'bn': 'খুব সুস্বাদু', 'ko': '아주 맛있어요', 'en': 'Very delicious'},

    // Emergency
    {'bn': 'আমি অসুস্থ', 'ko': '아파요', 'en': 'I am sick'},
    {'bn': 'ডাক্তার ডাকুন', 'ko': '의사를 불러주세요', 'en': 'Call a doctor'},
    {'bn': 'পুলিশ ডাকুন', 'ko': '경찰을 불러주세요', 'en': 'Call the police'},
    {'bn': 'অ্যাম্বুলেন্স ডাকুন', 'ko': '구급차를 불러주세요', 'en': 'Call an ambulance'},
    {'bn': 'জরুরি', 'ko': '긴급합니다', 'en': 'Emergency'},
  ];

  static List<Map<String, String>> searchPhrases(String query) {
    final queryLower = query.toLowerCase();
    return phrases.where((phrase) {
      return phrase['bn']!.toLowerCase().contains(queryLower) ||
          phrase['ko']!.toLowerCase().contains(queryLower) ||
          phrase['en']!.toLowerCase().contains(queryLower);
    }).toList();
  }

  static List<Map<String, String>> getPhrasesByCategory(String category) {
    final categories = {
      'greetings': phrases.sublist(0, 10),
      'common': phrases.sublist(10, 20),
      'travel': phrases.sublist(20, 25),
      'food': phrases.sublist(25, 30),
      'emergency': phrases.sublist(30, 35),
    };
    return categories[category] ?? phrases;
  }

  static List<String> get categories =>
      ['greetings', 'common', 'travel', 'food', 'emergency'];
}
