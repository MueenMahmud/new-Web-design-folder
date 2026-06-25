import 'package:equatable/equatable.dart';

class PhrasebookEntry extends Equatable {
  final String id;
  final String category;
  final String banglaText;
  final String koreanText;
  final String englishText;
  final String? banglaPronunciation;
  final String? koreanPronunciation;

  const PhrasebookEntry({
    required this.id,
    required this.category,
    required this.banglaText,
    required this.koreanText,
    required this.englishText,
    this.banglaPronunciation,
    this.koreanPronunciation,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        banglaText,
        koreanText,
        englishText,
        banglaPronunciation,
        koreanPronunciation,
      ];
}
