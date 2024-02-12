#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокПользовательскихПолей() Экспорт
	
	СписокПользовательскихПолей = Новый Соответствие;
	
	НаборЗаписей = РегистрыСведений.Б24_ПользовательскиеПоля.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	Для каждого ТекущаяЗапись Из НаборЗаписей Цикл
		СписокПользовательскихПолей.Вставить(ТекущаяЗапись.ПользовательскоеПоле, ТекущаяЗапись.ИмяПоля);
	КонецЦикла;
	
	Возврат СписокПользовательскихПолей;
	
КонецФункции

#КонецОбласти