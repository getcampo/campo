import LocalTime from "local-time"
import Current from "./current"

LocalTime.config.locale = Current.locale()
LocalTime.start()

LocalTime.config.i18n["zh-CN"] = {
  date: {
    abbrMonthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
    formats: {
      default: "%Y年%b月%e日",
      thisYear: "%b月%e日"
    }
  },
  time: {
    formats: {
      default: " %H:%M"
    }
  },
  datetime: {
    formats: {
      default: "%Y年%b月%e日 %H:%M"
    }
  }
}
