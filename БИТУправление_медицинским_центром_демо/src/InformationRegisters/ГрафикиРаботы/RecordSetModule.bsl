#Область РазделОписанияПеременных
Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений
#КонецОбласти

#Область ПрограммныйИнтерфейс
// Выполняет движения по регистру.
Процедура ВыполнитьДвижения() Экспорт

	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);

КонецПроцедуры // ВыполнитьДвижения()
#КонецОбласти