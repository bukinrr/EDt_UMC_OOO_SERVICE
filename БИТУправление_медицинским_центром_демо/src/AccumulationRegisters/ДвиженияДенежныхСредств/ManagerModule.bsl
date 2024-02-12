#Область ПрограммныйИнтерфейс

// Выполняет приходные документа движения по регистру накопления "ДвиженияДенежныхСредств".
//
// Параметры:
//  ПараметрыДокумента	 - Структура			 - структура с необходимыми параметрами документа
//  НаборЗаписей		 - РегистрНакопленияНаборЗаписей - набор записей по регистру "Движения денежных средств"
//  Приход				 - Булево						 - сли Истина, то выполняется операция прихода, если Ложь - расхода денежных средств.
//  Отказ				 - Булево						 - признак отмены проведения документа.
//
Процедура СформироватьДвиженияПоШапкеДокумента(ПараметрыДокумента,НаборЗаписей, Приход = Истина, Отказ = Ложь) Экспорт
	
	Движение = НаборЗаписей.Добавить();
	Движение.Период = ПараметрыДокумента.Дата;
	// Заполнение статьи ДДС и Кассы
	ЗаполнитьЗначенияСвойств(Движение,ПараметрыДокумента); 
	
	Движение.Сумма = ПараметрыДокумента.СуммаДокумента;
	Движение.ПриходРасход = ?(Приход, Перечисления.ВидыДвиженийПриходРасход.Приход, Перечисления.ВидыДвиженийПриходРасход.Расход);
	
	// Для совпадения при перепроведении старых документов после БИТ.УМЦ 2.0.47.22/2.1.23.17 (и дочерних конфигураций).
	Если Движение.Касса = Справочники.ЭквайринговыеТерминалы.ПустаяСсылка() Тогда
		Движение.Касса = Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
