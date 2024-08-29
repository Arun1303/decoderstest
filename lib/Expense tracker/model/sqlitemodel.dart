final String tableNotes = 'downloadsJson';

class DownloadsValueFields {
  static final List<String> values = [
    id,
    amount,
    category,
    timestamp
  ];
  static final String id = 'id';
  static final String amount = 'amount';
  static final String category = 'category';
  static final String timestamp = 'timestamp';
  
}

class DownloadsModel {
  final String? id;
  final String? amount;
  final String? category;
  final int? timestamp;
  
  DownloadsModel(
      {this.id,
      this.amount,
      this.category,
      this.timestamp,
    
    });

  DownloadsModel copy({
    String? id,
    String? amount,
    String? category,
    int? timestamp,
   
  }) =>
      DownloadsModel(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        timestamp: timestamp ?? this.timestamp,
       
      );

  static DownloadsModel fromJson(Map<String, Object?> json) => DownloadsModel(
        id: json[DownloadsValueFields.id] as String?,
        amount: json[DownloadsValueFields.amount] as String?,
        category: json[DownloadsValueFields.category] as String?,
        timestamp: json[DownloadsValueFields.timestamp] as int?,
        
      );

  Map<String, Object?> toJson() => {
        DownloadsValueFields.id: id,
        DownloadsValueFields.amount: amount,
        DownloadsValueFields.category: category,
        DownloadsValueFields.timestamp: timestamp,
       
      };
}
