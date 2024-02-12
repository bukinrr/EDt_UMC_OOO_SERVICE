#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Результат = Параметры.НачальноеЗначение;
	
	НастроитьЭлементыФормы();
	
	ЗаполнитьПоляПоНачальномуЗначению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Принять(Команда)
	
	Если Результат <> Параметры.НачальноеЗначение Тогда
		
		Ошибки = ФЛК();
		Если Ошибки.Количество() = 0 Тогда
			Закрыть(Результат);
		Иначе
			// Вывод ошибок
			ТекстПредупреждения = "Найдены ошибки:";
			Для Каждого Ошибка Из Ошибки Цикл
				ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + " - " + Ошибка;
			КонецЦикла;
			ПоказатьПредупреждение(, ТекстПредупреждения, 30);
		КонецЕсли;
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВсе(Команда)
	
	Трансфузии.Очистить();
	Результат = НСтр("ru='нет'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТрансфузииПриИзменении(Элемент)
	
	ВычислитьРезультатПоПолям();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// При создании на сервере
&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ТекущийГод = Год(ТекущаяДата());
	Для Сч = 1 По 20 Цикл
		Элементы.ТрансфузииГод.СписокВыбора.Добавить(Формат(ТекущийГод, "ЧГ="));
		ТекущийГод = ТекущийГод - 1;
	КонецЦикла;
	
КонецПроцедуры

// При создании на сервере
&НаСервере
Процедура ЗаполнитьПоляПоНачальномуЗначению()
	
	ЧастиРезультата = СтрРазделить(Результат, ";", Ложь);
	
	Для Каждого ЧастьРезультата Из ЧастиРезультата Цикл
		
		Год = "";
		Осложнения = "";
		ЧастьРезультата = СокрЛП(ЧастьРезультата);
		
		ЧастиСтроки = СтрРазделить(ЧастьРезультата, ":", Ложь);
		
		Если ЧастиСтроки.Количество() <> 0
			И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастиСтроки[0])
		Тогда
			Год = СокрЛП(ЧастиСтроки[0]);
			ЧастиСтроки.Удалить(0);
		КонецЕсли;
		
		Для Каждого ЧастьСтроки Из ЧастиСтроки Цикл
			Осложнения = Осложнения + ЧастьСтроки;
		КонецЦикла;
		
		Если Не ПустаяСтрока(Год + Осложнения) Тогда
			СтрокаТрансфузии = Трансфузии.Добавить();
			СтрокаТрансфузии.Год = Год;
			СтрокаТрансфузии.Осложнения = Осложнения;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВычислитьРезультатПоПолям()
	
	Результат = "";
	
	Для Каждого СтрокаТрансфузия Из Трансфузии Цикл
		
		ТекстСтроки = СтрокаТрансфузия.Год;
		ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(ТекстСтроки, СтрокаТрансфузия.Осложнения, ": ", Истина);
		
		ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(Результат, ТекстСтроки, "; ", Истина);	
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ФЛК()
	
	Ошибки = Новый Массив;
	
	Шаблон = "В строке №%1 %2";
	ДопустимаяДлинаГода = Новый Массив;
	ДопустимаяДлинаГода.Добавить(2);
	ДопустимаяДлинаГода.Добавить(4);
	
	Для Каждого СтрокаТрансфузии Из Трансфузии Цикл
		
		Год = СокрЛП(СтрокаТрансфузии.Год);
		НомерСтроки = Трансфузии.Индекс(СтрокаТрансфузии) + 1;
		
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Год)
			Или ДопустимаяДлинаГода.Найти(СтрДлина(Год)) = Неопределено
		Тогда
			Ошибки.Добавить(СтрШаблон(Шаблон, НомерСтроки, "неправильно указан год"));
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат Ошибки;
	
КонецФункции

#КонецОбласти