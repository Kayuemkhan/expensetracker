// app/data/local/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/data/model/budget.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        date INTEGER NOT NULL,
        merchant TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monthlyAmount REAL NOT NULL,
        dailyAmount REAL NOT NULL,
        month INTEGER NOT NULL
      )
    ''');
  }

  // Expense CRUD operations
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toJson());
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'expenses',
      where: 'date >= ? AND date < ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );

    return result.map((map) => Expense.fromJson(map)).toList();
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );

    return result.map((map) => Expense.fromJson(map)).toList();
  }

  Future<double> getTotalSpentForDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM expenses 
      WHERE date >= ? AND date < ?
    ''', [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch]);

    return result.first['total'] as double? ?? 0.0;
  }

  Future<Map<String, double>> getSpendingTrendData() async {
    final db = await database;
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    final result = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', datetime(date/1000, 'unixepoch')) as month,
        SUM(amount) as total
      FROM expenses 
      WHERE date >= ?
      GROUP BY month
      ORDER BY month
    ''', [threeMonthsAgo.millisecondsSinceEpoch]);

    Map<String, double> trendData = {};
    for (var row in result) {
      trendData[row['month'] as String] = row['total'] as double;
    }

    return trendData;
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Budget CRUD operations
  Future<int> insertBudget(Budget budget) async {
    final db = await database;
    return await db.insert('budgets', budget.toJson());
  }

  Future<Budget?> getCurrentBudget() async {
    final db = await database;
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final result = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [currentMonth.millisecondsSinceEpoch],
    );

    if (result.isNotEmpty) {
      return Budget.fromJson(result.first);
    }
    return null;
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await database;
    return await db.update(
      'budgets',
      budget.toJson(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }
}