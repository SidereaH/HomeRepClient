class HistoryItemModel {
  String date;
  String category;
  String shortDesc;
  String masterName;
  String address;
  int costs;


  HistoryItemModel(
       this.date,
       this.category,
      this.shortDesc,
      this.masterName,
      this.address,
      this.costs
      );
  String getItemCosts(){
    return "$costs р";
  }
}
