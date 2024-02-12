#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если Не ОбменДанными.Загрузка
		И Не ДополнительныеСвойства.Свойство("НеПроверятьПриЗаписи")
	Тогда
		Если Предопределенный Тогда
		  	Если Ссылка.Код <> Код Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Редактирование кода предопределенного элемента запрещено'"),,,,Отказ);
			КонецЕсли;		
		Иначе
			// Убрать проверку в метаданные, если в платформе исправлят ошибку обновления с одновременным изменением иерархии и
			// предопределенных.
			ТекстОшибки = "";
			Если ЭтоГруппа И Уровень() = 1 Тогда
				ТекстОшибки = НСтр("ru='Не допускается ввод групп второго уровня (подгрупп)'");
			ИначеЕсли Уровень() >= 2 Тогда
				ТекстОшибки = НСтр("ru='Не допускается ввод элементов в подгруппы справочника'");
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекстОшибки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

//	// Проверка уникальности кода
//	Если ЗначениеЗаполнено(Код) Тогда
//		РезультатыПоиска = Справочники.ПриказыМедосмотров.НайтиПоКоду(Код);
//		Если ЗначениеЗаполнено(РезультатыПоиска) Тогда
//			Отказ = Истина;
//			ОбщегоНазначения.СообщитьПользователю("Код не уникален!");
//		КонецЕсли;
//	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти