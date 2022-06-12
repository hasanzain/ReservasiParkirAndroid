class GeneralUtils {
  static List<String> months_ = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  static String parseDt(DateTime dt) {
    String hour = dt.hour < 10 ? "0" + dt.hour.toString() : dt.hour.toString();
    String minute =
        dt.minute < 10 ? "0" + dt.minute.toString() : dt.minute.toString();

    return "$hour:$minute ${dt.day} ${months_[dt.month + 1]} ${dt.year}";
  }

  static String formatCurrency(String currency) {
    String currencyString = currency;
    String result = "";

    int count = 1;
    for (int i = currencyString.length - 1; i >= 0; i--) {
      result = result + currencyString[i];
      if (count % 3 == 0 && i != 0) result = result + ".";

      count++;
    }

    String reversed = "";
    for (int i = result.length - 1; i >= 0; i--)
      reversed = reversed + result[i];

    return reversed;
  }
}
