class ReportQuerySort {
  static const createdTimeAsc = 'createdAt';
  static const createdTimeDesc = '-createdAt';
  static const updatedTimeAsc = 'updatedAt';
  static const updatedTimeDesc = '-updatedAt';
}

class ReportQueryInclude {
  static const reporter = 'reporter';
  static const message = 'message';
}

class ReportStatus {
  static const pending = 'pending';
  static const cancelled = 'cancelled';
  static const reviewing = 'reviewing';
  static const rejected = 'rejected';
  static const completed = 'completed';
}

class ReportType {
  static const account = 'account';
  static const organization = 'organization';
  static const activity = 'activity';
  static const news = 'news';
}