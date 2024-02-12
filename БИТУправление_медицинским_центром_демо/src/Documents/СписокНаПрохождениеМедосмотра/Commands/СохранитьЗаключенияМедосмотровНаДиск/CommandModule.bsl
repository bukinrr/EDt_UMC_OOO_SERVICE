#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) 
	
	СписокПрохожденийМОДляСохранения = ПолучитьСписокЗавершенныхМО(ПараметрКоманды);  
	Если СписокПрохожденийМОДляСохранения.Количество() = 0 Тогда
		ПоказатьПредупреждение(,"Нет заключений для сохранения");
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога; 
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим); 
	ДиалогОткрытия.Каталог = ""; 
	ДиалогОткрытия.МножественныйВыбор = Ложь; 
	ДиалогОткрытия.Заголовок = "Выберите каталог для сохранения"; 
	
	Если ДиалогОткрытия.Выбрать() Тогда 
		СохранитьПрохожденияМОPDF(ДиалогОткрытия.Каталог, СписокПрохожденийМОДляСохранения);
		ПоказатьПредупреждение(,"Сохранено " + СписокПрохожденийМОДляСохранения.Количество() + " файла(ов)");
	КонецЕсли; 

КонецПроцедуры  

&НаСервере
Функция ПолучитьСписокЗавершенныхМО(СписокНаПрохождениеМО)
	
	СписокЗавершенныхМО = Новый Массив();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПрохождениеМедосмотра.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ПрохождениеМедосмотра КАК ПрохождениеМедосмотра
	               |ГДЕ
	               |	ПрохождениеМедосмотра.СписокНаПрохождениеМедосмотра = &Список
	               |	И ПрохождениеМедосмотра.ДатаЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	               |	И НЕ ПрохождениеМедосмотра.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Список", СписокНаПрохождениеМО);
	Выборка = Запрос.Выполнить().Выбрать();  
	
	Пока Выборка.Следующий() Цикл  
		СписокЗавершенныхМО.Добавить(Выборка.Ссылка);
	КонецЦикла; 
	
	Возврат СписокЗавершенныхМО;
	
КонецФункции          

&НаКлиенте
Процедура СохранитьПрохожденияМОPDF(Каталог, СписокПрохожденийМОДляСохранения)
	
	ПечатныеФормы = СформироватьТабДокументы(СписокПрохожденийМОДляСохранения, "Заключение");
	
	Для Каждого ОписаниеДокумента Из ПечатныеФормы Цикл
		ИмяФайла = Каталог + ПолучитьРазделительПутиКлиента() + ИмяФайлаЗаключения(ОписаниеДокумента);
		ОписаниеДокумента.ТабДокумент.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.PDF);
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Функция СформироватьТабДокументы(СписокПрохожденийМОДляСохранения, ИмяМакета)
	
	мТабДокументов = Новый Массив;
	Для Каждого Прохождение Из СписокПрохожденийМОДляСохранения Цикл 
		ПрохождениеМО = Новый Структура;
		ПрохождениеМО.Вставить("ТабДокумент", Документы.ПрохождениеМедосмотра.Печать(Прохождение, ИмяМакета));
		ПрохождениеМО.Вставить("ДатаЗавершения", Прохождение.ДатаЗавершения);
		ПрохождениеМО.Вставить("Клиент", ОбщегоНазначения.ФИОФизЛица(Прохождение.Клиент));
		
		мТабДокументов.Добавить(ПрохождениеМО); 
	КонецЦикла;
	
	Возврат мТабДокументов;
	
КонецФункции

&НаКлиенте
Функция ИмяФайлаЗаключения(ОписаниеДокумента)
	
	ШаблонИмениФайла = "%2. Заключение медосмотра от %1.";
	
	ИмяФайла = СтрШаблон(ШаблонИмениФайла,
						 Формат(ОписаниеДокумента.ДатаЗавершения, "ДЛФ=Д"),
						 ОписаниеДокумента.Клиент);
						 
	Возврат ИмяФайла + ".pdf";

КонецФункции

#КонецОбласти