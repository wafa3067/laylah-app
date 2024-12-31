import 'package:flutter/material.dart';

class SetStateClass with ChangeNotifier {
  // seting categories
  int cate_index = 0;
  int get _cate_index => cate_index;
  setCateindex(index) {
    cate_index = index;
    notifyListeners();
  }
  bool submitLoad = false;
  bool get _submitLoad => submitLoad;
  setSubmitLoad(index) {
    submitLoad = index;
    notifyListeners();
  }

  // seting categories
  int current_index = 0;
  int get _current_index => cate_index;
  setCurrentIndex(index) {
    current_index = index;
    notifyListeners();
  }

  // seting categories
   List selectedTags = []; // To store selected tags
  List get selectedTagsData => selectedTags;
  setTags(index) {
    selectedTags = index;
    notifyListeners();
  }


  String? selectNoval;
  String? SelectStatus;
  String? SelectGenre;

  String? get  selectedNoval=>selectNoval;
  String? get SelectedStatus =>SelectStatus;
  String? get SelectedGenre =>SelectGenre;


  setNoval(value){
     selectNoval = value;
    notifyListeners();
  }
  setStatus(value){
    SelectStatus = value;
    notifyListeners();
  }
  setGenre(value){
 SelectGenre = value;
    notifyListeners();
  }


  bool offlinecompleted = false;
  bool get _offlinecompleted => offlinecompleted;
  SetOfflineCompleted(bool value) {
    offlinecompleted = value;
    notifyListeners();
  }

  bool loadImage = true;
  bool get _loadImage => loadImage;
  SetLoadImage(bool value) {
    loadImage = value;
    notifyListeners();
  }

  bool day = false;
  bool get _day => day;
  SetDay(bool value) {
    day = value;
    notifyListeners();
  }

  bool check = false;
  bool get _check => check;
  SetCheckBox(bool value) {
    check = value;
    notifyListeners();
  }

  bool current_user = false;
  bool get _current_user => current_user;
  setCurrentUser(bool value) {
    current_user = value;
    notifyListeners();
  }

  bool other_site = false;
  bool get _other_site => other_site;
  SetOtherSite(bool value) {
    other_site = value;
    notifyListeners();
  }

  // seting categories
  int likes_length = 0;
  int get _likes_length => likes_length;
  setLikesLength(index) {
    likes_length = index;
    notifyListeners();
  }

  // seting categories
  bool current_user_book = false;
  bool get _current_user_book => current_user_book;
  setCurrentUserBooks(index) {
    current_user_book = index;
    notifyListeners();
  }

  // seting categories
  bool connection = false;
  bool get _connection => connection;
  setConnection(bool con) {
    connection = con;
    notifyListeners();
  }

  // seting categories
  String search = '';
  String get _search => search;
  setSearch(String con) {
    search = con;
    notifyListeners();
  }

  // seting categories
  String searchTap = '';
  String get _searchTap => searchTap;
  setSearchTap(String con) {
    searchTap = con;
    notifyListeners();
  }

  // seting categories
  String rewardLoad = '';
  String get _rewardLoad => rewardLoad;
  setRewardLoad(con) {
    rewardLoad = con;
    notifyListeners();
  }

  // seting draft publish trash
  bool trash = false;
  bool publish = false;
  bool draft = true;
  int draft_index = 0;
  bool get _trash => trash;
  bool get _publish => publish;
  bool get _draft => draft;
  int get _draft_index => draft_index;
  updatedraft(bool draft_value, bool trash_value, bool publish_value, index) {
    trash = trash_value;
    publish = publish_value;
    draft = draft_value;
    draft_index = index;

    notifyListeners();
  }

  bool switch_value = false;
  bool get _switch_value => switch_value;
  updateSwicth(bool value) {
    switch_value = value;
    notifyListeners();
  }

  bool age_check = false;
  bool get _age_check => age_check;
  setAge(bool value) {
    age_check = value;
    notifyListeners();
  }

  bool Exclusive = false;
  bool get _Exclusive => Exclusive;
  setExclusive(bool value) {
    Exclusive = value;
    notifyListeners();
  }


  // grid books
  List book_image = [];
  List book_title = [];
  List book_id = [];
  List library=[];

  List get bookImage=>book_image;
  List get bookTitle=>book_title;
  List get bookId=>book_id;
  List get Library=>library;

  GetBooks( book, cover, id,lib){
    book_title.add(book);
    book_image.add(cover);
    book_id.add(id);
    library.add(lib);
    notifyListeners();
  }


  bool type_of_contract = false;
  bool get _type_of_contract => type_of_contract;
  Settypeofcontract(bool value) {
    type_of_contract = value;
    notifyListeners();
  }

  bool bookmark = false;
  bool isAvailable = false;
  bool get _bookmark => bookmark;
  bool get _isAvailable => isAvailable;
  BookMark(bool value,bool av) {
    bookmark = value;
    isAvailable=av;
    notifyListeners();
  }

  bool show = false;
  bool get _show => show;
  ShowHide(bool value) {
    show = value;
    notifyListeners();
  }

  //loading books
  bool load_book = true;
  bool get _load_book => load_book;
  LoadBook(bool value) {
    load_book = value;
    notifyListeners();
  }

  bool saveIncome = false;
  bool get _saveIncome => saveIncome;
  setsaveIncome(bool value) {
    saveIncome = value;
    notifyListeners();
  }

  bool payoneer = false;
  bool get _payoneer => payoneer;
  setSavePayoneer(bool value) {
    payoneer = value;
    notifyListeners();
  }

  bool id_card = true;
  bool passport_check = false;
  bool driving_check = false;
  bool get _id => payoneer;
  bool get _passport => payoneer;
  bool get _driving => payoneer;
  setSaveDocument({id, passport, driving}) {
    id_card = id;
    passport_check = passport;
    driving_check = driving;
    notifyListeners();
  }

  bool agree = false;
  bool get _agree => agree;
  setSaveAgree(bool value) {
    agree = value;
    notifyListeners();
  }

  String country_code = '';
  String get _country_code => country_code;
  setCountryCode(String value) {
    country_code = value;
    notifyListeners();
  }

  String bank = 'Bank';
  String get _bank => bank;
  setBank(value) {
    bank = value;
    notifyListeners();
  }

  String userid = '';
  String get _userid => userid;
  setUserid(value) {
    userid = value;
    notifyListeners();
  }
}
