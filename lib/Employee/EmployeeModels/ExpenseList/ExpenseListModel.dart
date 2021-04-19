class EmployeeExpenseListModel {
  int totalCount;
  List<Items> items;

  EmployeeExpenseListModel({this.totalCount, this.items});

  EmployeeExpenseListModel.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String expenseId;
  String expenseCode;
  String expenseAmount;
  String expenseDate;
  String billNumber;
  String etypeId;
  String etypeCode;
  String etypeName;
  String expenseBy;

  Items(
      {this.expenseId,
      this.expenseCode,
      this.expenseAmount,
      this.expenseDate,
      this.billNumber,
      this.etypeId,
      this.etypeCode,
      this.etypeName,
      this.expenseBy});

  Items.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'];
    expenseCode = json['expense_code'];
    expenseAmount = json['expense_amount'];
    expenseDate = json['expense_date'];
    billNumber = json['bill_number'];
    etypeId = json['etype_id'];
    etypeCode = json['etype_code'];
    etypeName = json['etype_name'];
    expenseBy = json['expense_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense_id'] = this.expenseId;
    data['expense_code'] = this.expenseCode;
    data['expense_amount'] = this.expenseAmount;
    data['expense_date'] = this.expenseDate;
    data['bill_number'] = this.billNumber;
    data['etype_id'] = this.etypeId;
    data['etype_code'] = this.etypeCode;
    data['etype_name'] = this.etypeName;
    data['expense_by'] = this.expenseBy;
    return data;
  }
}
