#Область ПрограммныйИнтерфейс

Функция ПолучитьGTIN(Номенклатура, СерияНоменклатуры = Неопределено) Экспорт
	
	НаборGTIN	= Новый Массив();
	Запрос		= Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПОДСТРОКА(УпаковкиМаркируемогоТовара.НомерУпаковки, 1, 14) КАК GTIN
		|ПОМЕСТИТЬ Таблица
		|ИЗ
		|	Справочник.УпаковкиМаркируемогоТовара КАК УпаковкиМаркируемогоТовара
		|ГДЕ
		|	УпаковкиМаркируемогоТовара.Номенклатура = &Номенклатура
		|	И (&НеИспользоватьОтборПоСерии
		|			ИЛИ УпаковкиМаркируемогоТовара.СерияНоменклатуры = &СерияНоменклатуры)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.GTIN КАК GTIN
		|ИЗ
		|	Таблица КАК Таблица";
	
	Запрос.УстановитьПараметр("НеИспользоватьОтборПоСерии", НЕ ЗначениеЗаполнено(СерияНоменклатуры));
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборGTIN.Добавить(ВыборкаДетальныеЗаписи.GTIN);
	КонецЦикла;
	
	Возврат НаборGTIN;
	
КонецФункции

Функция ВедетсяУчетМДЛП() Экспорт
	Возврат ПолучитьФункциональнуюОпцию("ВестиСведенияДляМониторингаДвиженияЛекарственныхПрепаратов");
КонецФункции

Функция ПолучитьПериодВыполненияОбменаМДЛП() Экспорт
	ПериодОбмена = Константы.ПериодВыполненияОбменаДаннымиМДЛП.Получить();
	Если ПериодОбмена = 0 Тогда
		ПериодОбмена = 60;
	КонецЕсли;
	
	Возврат ПериодОбмена;
КонецФункции

#КонецОбласти
