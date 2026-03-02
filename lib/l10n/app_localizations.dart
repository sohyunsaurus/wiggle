// l10n/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common
  String get appTitle =>
      locale.languageCode == 'ko' ? '소원을 빌어요 ✨' : 'Make a Wish ✨';
  String get cancel => locale.languageCode == 'ko' ? '취소' : 'Cancel';
  String get confirm => locale.languageCode == 'ko' ? '확인' : 'Confirm';
  String get delete => locale.languageCode == 'ko' ? '삭제' : 'Delete';
  String get save => locale.languageCode == 'ko' ? '저장' : 'Save';
  String get edit => locale.languageCode == 'ko' ? '편집' : 'Edit';
  String get close => locale.languageCode == 'ko' ? '닫기' : 'Close';

  // Bottom Navigation
  String get navWishes => locale.languageCode == 'ko' ? '소원' : 'Wishes';
  String get navCalendar => locale.languageCode == 'ko' ? '달력' : 'Calendar';
  String get navCollection =>
      locale.languageCode == 'ko' ? '컬렉션' : 'Collection';
  String get navSettings => locale.languageCode == 'ko' ? '설정' : 'Settings';

  // Wishes Screen
  String get makeWishTitle =>
      locale.languageCode == 'ko' ? '소원을 빌어요 ✨' : 'Make a Wish ✨';
  String get newWish => locale.languageCode == 'ko' ? '새 소원' : 'New Wish';
  String get noWishesToday =>
      locale.languageCode == 'ko' ? '오늘은 아직 소원이 없어요' : 'No wishes yet today';
  String get tapToMakeWish => locale.languageCode == 'ko'
      ? '아래 버튼을 눌러서 첫 번째 소원을 빌어보세요! ✨'
      : 'Tap the button below to make your first wish! ✨';

  // Wish Form
  String get whatWish => locale.languageCode == 'ko'
      ? '무엇을 소원으로 빌고 싶나요? *'
      : 'What do you wish for? *';
  String get whyImportant =>
      locale.languageCode == 'ko' ? '왜 이것이 중요한가요?' : 'Why is this important?';
  String get whenWant =>
      locale.languageCode == 'ko' ? '언제까지 이루고 싶나요?' : 'When do you want this?';
  String get whereHappen =>
      locale.languageCode == 'ko' ? '어디서 일어날까요?' : 'Where will this happen?';
  String get whoInvolved =>
      locale.languageCode == 'ko' ? '누가 관련되어 있나요?' : 'Who is involved?';
  String get howMakeHappen => locale.languageCode == 'ko'
      ? '어떻게 이룰 수 있을까요?'
      : 'How will you make it happen?';
  String get importance => locale.languageCode == 'ko' ? '중요도' : 'Importance';
  String get category => locale.languageCode == 'ko' ? '카테고리' : 'Category';
  String get makeWish => locale.languageCode == 'ko' ? '소원 빌기' : 'Make Wish';
  String get updateWish =>
      locale.languageCode == 'ko' ? '소원 수정' : 'Update Wish';
  String get editWish =>
      locale.languageCode == 'ko' ? '소원 편집 ✨' : 'Edit Wish ✨';

  // Categories
  String get categoryPersonal =>
      locale.languageCode == 'ko' ? '개인적인' : 'Personal';
  String get categoryCareer => locale.languageCode == 'ko' ? '커리어' : 'Career';
  String get categoryHealth => locale.languageCode == 'ko' ? '건강' : 'Health';
  String get categoryRelationships =>
      locale.languageCode == 'ko' ? '인간관계' : 'Relationships';
  String get categoryFinancial =>
      locale.languageCode == 'ko' ? '재정' : 'Financial';
  String get categorySpiritual =>
      locale.languageCode == 'ko' ? '영적인' : 'Spiritual';

  // Calendar Screen
  String get wishCalendar =>
      locale.languageCode == 'ko' ? '소원 달력' : 'Wish Calendar';
  String get totalWishes =>
      locale.languageCode == 'ko' ? '총 소원' : 'Total Wishes';
  String get fulfilledWishes =>
      locale.languageCode == 'ko' ? '이뤄진 소원' : 'Fulfilled';
  String get activeDays => locale.languageCode == 'ko' ? '활동일' : 'Active Days';
  String get noWishesThisDay =>
      locale.languageCode == 'ko' ? '이 날에는 소원이 없어요' : 'No wishes on this day';

  // Collection Screen
  String get myCollection => locale.languageCode == 'ko'
      ? '나의 타마고치 컬렉션 ✨'
      : 'My Tamagotchi Collection ✨';
  String get noFriendsYet => locale.languageCode == 'ko'
      ? '아직 타마고치 친구가 없어요'
      : 'No tamagotchi friends yet';
  String get fulfillWishesToUnlock => locale.languageCode == 'ko'
      ? '소원을 이뤄서 사랑스러운 친구들을 잠금해제하세요! ✨'
      : 'Fulfill your wishes to unlock adorable companions! ✨';
  String get makeWishes =>
      locale.languageCode == 'ko' ? '소원 빌기' : 'Make Wishes';
  String get collectionProgress =>
      locale.languageCode == 'ko' ? '컬렉션 진행도' : 'Collection Progress';
  String get friendsCollected =>
      locale.languageCode == 'ko' ? '모은 친구들' : 'friends collected';
  String get goldenCompanions =>
      locale.languageCode == 'ko' ? '황금 친구들' : 'golden companions';

  // Settings Screen
  String get settings => locale.languageCode == 'ko' ? '설정' : 'Settings';
  String get appInfo => locale.languageCode == 'ko' ? '앱 정보' : 'App Info';
  String get dataManagement =>
      locale.languageCode == 'ko' ? '데이터 관리' : 'Data Management';
  String get dangerZone =>
      locale.languageCode == 'ko' ? '위험 구역' : 'Danger Zone';
  String get language => locale.languageCode == 'ko' ? '언어' : 'Language';
  String get korean => locale.languageCode == 'ko' ? '한국어' : 'Korean';
  String get english => locale.languageCode == 'ko' ? '영어' : 'English';
  String get selectLanguage =>
      locale.languageCode == 'ko' ? '언어 선택' : 'Select Language';

  String get appDescription => locale.languageCode == 'ko'
      ? '매일 소원을 빌고 귀여운 타마고치 친구들을 모아보세요!'
      : 'Make daily wishes and collect cute tamagotchi friends!';

  String get version => locale.languageCode == 'ko' ? '버전' : 'Version';
  String get developer => locale.languageCode == 'ko' ? '개발자' : 'Developer';

  String get dataBackup =>
      locale.languageCode == 'ko' ? '데이터 백업' : 'Data Backup';
  String get dataRestore =>
      locale.languageCode == 'ko' ? '데이터 복원' : 'Data Restore';
  String get viewStats =>
      locale.languageCode == 'ko' ? '통계 보기' : 'View Statistics';
  String get backupDescription => locale.languageCode == 'ko'
      ? '소원과 캐릭터 데이터를 백업합니다'
      : 'Backup wishes and character data';
  String get restoreDescription =>
      locale.languageCode == 'ko' ? '백업된 데이터를 복원합니다' : 'Restore backed up data';
  String get statsDescription => locale.languageCode == 'ko'
      ? '상세한 소원 달성 통계를 확인합니다'
      : 'View detailed wish achievement statistics';

  String get deleteAllWishes =>
      locale.languageCode == 'ko' ? '모든 소원 삭제' : 'Delete All Wishes';
  String get deleteAllCharacters =>
      locale.languageCode == 'ko' ? '모든 캐릭터 삭제' : 'Delete All Characters';
  String get deleteAllData =>
      locale.languageCode == 'ko' ? '모든 데이터 삭제' : 'Delete All Data';
  String get deleteWishesDescription => locale.languageCode == 'ko'
      ? '모든 소원 기록을 삭제합니다 (복구 불가능)'
      : 'Delete all wish records (irreversible)';
  String get deleteCharactersDescription => locale.languageCode == 'ko'
      ? '모든 타마고치 컬렉션을 삭제합니다 (복구 불가능)'
      : 'Delete all tamagotchi collection (irreversible)';
  String get deleteAllDataDescription => locale.languageCode == 'ko'
      ? '앱의 모든 데이터를 완전히 삭제합니다 (복구 불가능)'
      : 'Completely delete all app data (irreversible)';

  // Statistics
  String get myStatistics =>
      locale.languageCode == 'ko' ? '📊 나의 통계' : '📊 My Statistics';
  String get totalWishesCount =>
      locale.languageCode == 'ko' ? '총 소원 개수' : 'Total Wishes';
  String get fulfilledWishesCount =>
      locale.languageCode == 'ko' ? '이뤄진 소원' : 'Fulfilled Wishes';
  String get activeDaysCount =>
      locale.languageCode == 'ko' ? '활동일' : 'Active Days';
  String get collectedCharacters =>
      locale.languageCode == 'ko' ? '모은 캐릭터' : 'Collected Characters';
  String get goldenCharacters =>
      locale.languageCode == 'ko' ? '황금 캐릭터' : 'Golden Characters';
  String get achievementRate =>
      locale.languageCode == 'ko' ? '달성률' : 'Achievement Rate';

  // Error Messages
  String get errorOccurred =>
      locale.languageCode == 'ko' ? '오류가 발생했습니다' : 'An error occurred';
  String get tryAgain => locale.languageCode == 'ko' ? '다시 시도' : 'Try Again';
  String get pleaseEnterWish => locale.languageCode == 'ko'
      ? '소원을 입력해주세요'
      : 'Please enter what you wish for';
  String get loadingStatsError => locale.languageCode == 'ko'
      ? '통계를 불러오는 중 오류가 발생했습니다'
      : 'Error loading statistics';
  String get deletionError =>
      locale.languageCode == 'ko' ? '삭제 중 오류가 발생했습니다' : 'Error during deletion';

  // Success Messages
  String get allWishesDeleted => locale.languageCode == 'ko'
      ? '모든 소원이 삭제되었습니다'
      : 'All wishes have been deleted';
  String get allCharactersDeleted => locale.languageCode == 'ko'
      ? '모든 캐릭터가 삭제되었습니다'
      : 'All characters have been deleted';
  String get allDataDeleted => locale.languageCode == 'ko'
      ? '모든 데이터가 삭제되었습니다'
      : 'All data has been deleted';
  String get restartRecommended => locale.languageCode == 'ko'
      ? '모든 데이터가 삭제되었습니다.\n앱을 재시작하는 것을 권장합니다.'
      : 'All data has been deleted.\nRestarting the app is recommended.';

  // Confirmation Messages
  String get deleteWishesConfirm => locale.languageCode == 'ko'
      ? '모든 소원 기록을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.'
      : 'Delete all wish records?\n\nThis action cannot be undone.';
  String get deleteCharactersConfirm => locale.languageCode == 'ko'
      ? '모든 타마고치 캐릭터를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.'
      : 'Delete all tamagotchi characters?\n\nThis action cannot be undone.';
  String get deleteAllDataConfirm => locale.languageCode == 'ko'
      ? '정말로 모든 데이터를 삭제하시겠습니까?\n\n• 모든 소원 기록\n• 모든 타마고치 캐릭터\n• 모든 설정\n\n이 작업은 절대 되돌릴 수 없습니다!'
      : 'Really delete all data?\n\n• All wish records\n• All tamagotchi characters\n• All settings\n\nThis action is absolutely irreversible!';
  String get finalConfirmation =>
      locale.languageCode == 'ko' ? '⚠️ 최종 확인' : '⚠️ Final Confirmation';
  String get typeDeleteToConfirm => locale.languageCode == 'ko'
      ? '정말로 모든 데이터를 삭제하려면 아래에 "삭제"를 입력하세요:'
      : 'To really delete all data, type "DELETE" below:';
  String get deleteText => locale.languageCode == 'ko' ? '삭제' : 'DELETE';

  // Coming Soon
  String get comingSoon =>
      locale.languageCode == 'ko' ? '🚧 준비중' : '🚧 Coming Soon';
  String get featureComingSoon => locale.languageCode == 'ko'
      ? '이 기능은 곧 추가될 예정입니다!'
      : 'This feature will be added soon!';

  // Additional Wish Form Hints
  String get whatHint => locale.languageCode == 'ko'
      ? '예: 새로운 언어 배우기'
      : 'e.g., Learn a new language';
  String get whyHint => locale.languageCode == 'ko'
      ? '예: 더 넓은 세상을 경험하고 싶어서'
      : 'e.g., To experience a broader world';
  String get whenHint => locale.languageCode == 'ko'
      ? '예: 올해 안에'
      : 'e.g., By the end of this year';
  String get whereHint => locale.languageCode == 'ko'
      ? '예: 온라인 강의실에서'
      : 'e.g., In online classrooms';
  String get whoHint =>
      locale.languageCode == 'ko' ? '예: 나 혼자서' : 'e.g., Just myself';
  String get howHint => locale.languageCode == 'ko'
      ? '예: 매일 30분씩 공부하기'
      : 'e.g., Study 30 minutes daily';

  // Delete Confirmation
  String get deleteWishTitle =>
      locale.languageCode == 'ko' ? '소원 삭제' : 'Delete Wish';
  String get deleteWishMessage => locale.languageCode == 'ko'
      ? '정말로 이 소원을 삭제하시겠습니까?'
      : 'Are you sure you want to delete this wish?';

  // Character Collection Details
  String get collectedOn => locale.languageCode == 'ko' ? '수집일' : 'Collected';
  String get rarity => locale.languageCode == 'ko' ? '희귀도' : 'Rarity';
  String get evolution => locale.languageCode == 'ko' ? '진화 단계' : 'Evolution';
  String get stats => locale.languageCode == 'ko' ? '능력치' : 'Stats';
  String get happiness => locale.languageCode == 'ko' ? '행복도' : 'Happiness';
  String get energy => locale.languageCode == 'ko' ? '에너지' : 'Energy';
  String get goldenMessage => locale.languageCode == 'ko'
      ? '이 친구는 관련된 모든 소원이 이뤄져서 황금빛으로 빛나고 있어요! ✨'
      : 'This companion glows golden because all related wishes have been fulfilled! ✨';

  // Progress Indicator
  String get todayProgress =>
      locale.languageCode == 'ko' ? '오늘의 진행률' : 'Today\'s Progress';
  String get completed => locale.languageCode == 'ko' ? '완료' : 'completed';
  String get daysStreak =>
      locale.languageCode == 'ko' ? '일 연속' : ' days streak';
  String get characterUnlockAvailable => locale.languageCode == 'ko'
      ? '캐릭터 획득 가능!'
      : 'Character unlock available!';
  String get allTasksCompleted => locale.languageCode == 'ko'
      ? '🎉 모든 할일을 완료했어요! 새로운 친구가 기다리고 있어요!'
      : '🎉 All tasks completed! A new friend is waiting for you!';
  String tasksRemaining(int count) => locale.languageCode == 'ko'
      ? '좋아요! $count개만 더 완료하면 새 친구를 만날 수 있어요!'
      : 'Great! Complete $count more to meet a new friend!';
  String get startYourDay => locale.languageCode == 'ko'
      ? '오늘도 화이팅! 하나씩 완료해서 귀여운 친구를 모아보세요 🌟'
      : 'Let\'s go! Complete tasks one by one to collect cute friends 🌟';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
