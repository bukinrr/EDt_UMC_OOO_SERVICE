#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Текст = Параметры.Текст;
	
	Параметр = Параметры.Параметр;
	Заголовок = Строка(Параметр);
	
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	
	УстановитьОтборСпискаФраз();	
	
	ЗаполнитьДеревоЗначенийВыбораИзТабличнойЧасти();
	УстановитьОтображениеСтраницыЗначенийВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Элементы.Текст.УстановитьГраницыВыделения(СтрДлина(Текст)+1, СтрДлина(Текст)+1, СтрДлина(Текст)+1, СтрДлина(Текст)+1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	// Сохранение значения знака разделителя для этого параметра
	РазделительГФ = Неопределено;
	Для Каждого Элемент Из Элементы.ФразыГруппаЗнакиПрепинания.ПодчиненныеЭлементы Цикл
		Если ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(Элемент, "Пометка", Ложь) Тогда
			РазделительГФ = Элемент.Имя;
		КонецЕсли;
	КонецЦикла;
	
	// Сохранение разделителя готовых фраз для восстановления при следующем открытии.
	Если РазделительГФ <> РазделительГФПриОткрытии Тогда
		ИмяНастройки = ИмяНастройкиРазделителяГФ(Параметр);
		Если ЗначениеЗаполнено(РазделительГФ) Тогда // Сохранение настройки.
			РаботаСФормамиСервер.СохранитьНастройкуФормы(ИмяНастройки, Неопределено, РазделительГФ);
		Иначе // Удаление настройки.
			РаботаСФормамиСервер.УдалитьНастройкуФормы(ИмяНастройки, Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоЗначенийВыбораИзТабличнойЧасти()
	
	ЗагрузитьВершинуДереваЗначенийВыбора(0);
	 
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВершинуДереваЗначенийВыбора(КлючРодителя, Вершина = Неопределено)
	
	Если Вершина = Неопределено Тогда
		Вершина = ДеревоЗначенийВыбора;	
	КонецЕсли; 
	
	ПодчиненныеСтроки = Параметр.ЗначенияВыбора.НайтиСтроки(Новый Структура("КлючРодителя",КлючРодителя));
	Для Каждого Строка Из ПодчиненныеСтроки Цикл
		НоваяВершина = Вершина.ПолучитьЭлементы().Добавить();
		НоваяВершина.Значение		  = Строка.Значение;
		НоваяВершина.Представление	  = ?(ЗначениеЗаполнено(Строка.Представление), Строка.Представление, Строка.Значение);
		НоваяВершина.ЭтоГруппа		  = Строка.ЭтоГруппа;
		НоваяВершина.КартинкаИерархии = Число(Не Строка.ЭтоГруппа) + 1;
		ЗагрузитьВершинуДереваЗначенийВыбора(Строка.КлючСтроки, НоваяВершина);
	КонецЦикла; 
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеСтраницыЗначенийВыбора()
	Элементы.СтраницаЗначенияВыбора.Видимость = ДеревоЗначенийВыбора.ПолучитьЭлементы().Количество() > 0;
	Если Элементы.СтраницаЗначенияВыбора.Видимость Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = Фразы.ТекстЗапроса;
		Запрос.УстановитьПараметр("Параметр", Параметр);
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
		Если Запрос.Выполнить().Выбрать().Следующий() Тогда
			Элементы.СтраницыГотовыхФраз.ТекущаяСтраница = Элементы.СтраницаГотовыеФразы;
		Иначе
			Элементы.СтраницыГотовыхФраз.ТекущаяСтраница = Элементы.СтраницаЗначенияВыбора;	
		КонецЕсли; 	
	Иначе
		Элементы.СтраницыГотовыхФраз.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	КонецЕсли;
	
	// Восстановление настройки кнопки разделителя по умолчанию (при создании формы).
	ИмяНастройки = ИмяНастройкиРазделителяГФ(Параметр);
	РазделительГФ = РаботаСФормамиСервер.ПолучитьНастройкуФормы(ИмяНастройки, Неопределено, Неопределено);
	Если ЗначениеЗаполнено(РазделительГФ)
		И ТипЗнч(РазделительГФ) = Тип("Строка")
	Тогда
		Кнопка = Элементы.Найти(РазделительГФ);
		Если Кнопка <> Неопределено Тогда
			Кнопка.Пометка = Истина;
		КонецЕсли;
		Кнопка = Элементы.Найти(РазделительГФ+"ЗВ");
		Если Кнопка <> Неопределено Тогда
			Кнопка.Пометка = Истина;
		КонецЕсли;
		
		РазделительГФПриОткрытии = РазделительГФ;
	Иначе
		РазделительГФПриОткрытии = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСпискаФраз()
	
	Фразы.Параметры.УстановитьЗначениеПараметра("Параметр", Параметр);
	
	Фразы.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
	
	Элементы.Фразы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗнакТочки(Команда)
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинания,	  Элементы.ЗнакТочка,   Истина);
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинанияЗВ, Элементы.ЗнакТочкаЗВ, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗнакЗапятой(Команда)
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинания,   Элементы.ЗнакЗапятая,   Истина);
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинанияЗВ, Элементы.ЗнакЗапятаяЗВ, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗнакТочкиСЗапятой(Команда)
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинания,   Элементы.ЗнакТочкаСЗапятой,   Истина);
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинанияЗВ, Элементы.ЗнакТочкаСЗапятойЗВ, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗнакПереносСтроки(Команда)
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинания,   Элементы.ЗнакПереносСтроки,   Истина);
	РаботаСФормамиКлиент.УстановитьПометкуКнопкиГруппы(Элементы.ФразыГруппаЗнакиПрепинанияЗВ, Элементы.ЗнакПереносСтрокиЗВ, Истина);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяНастройкиРазделителяГФ(ПараметрМД)
	Возврат "РазделительГФ-" + СтрЗаменить(Строка(ПараметрМД.УникальныйИдентификатор()), "-","_");
КонецФункции

&НаКлиенте
Процедура ФразыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекстФразы = ПолучитьТекстФразы(ВыбраннаяСтрока);
	ПодставитьВыбранныйТекст(ТекстФразы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодставитьВыбранныйТекст(ТекстФразы)
	
	// Подготовка текста фразы
	Если Элементы.ЗнакЗапятая.Пометка Тогда
		Если ЗначениеЗаполнено(Текст) Тогда
			ТекстФразы = ", " + СокрЛП(ТекстФразы);
		Иначе 
			ТекстФразы = СокрЛП(ТекстФразы);
		КонецЕсли;
	ИначеЕсли Элементы.ЗнакТочкаСЗапятой.Пометка Тогда
		ТекстФразы = " " + СокрЛП(ТекстФразы) + ";";
	ИначеЕсли Элементы.ЗнакТочка.Пометка Тогда
		ТекстФразы = " " + СокрЛП(ТекстФразы) + ".";
	ИначеЕсли Элементы.ЗнакПереносСтроки.Пометка Тогда
		Если Не ЗначениеЗаполнено(Элементы.Текст.ТекстРедактирования) Тогда 
			ТекстФразы = СокрЛП(ТекстФразы);
		Иначе
			ТекстФразы = Символы.ПС + СокрЛП(ТекстФразы);
		КонецЕсли;
	КонецЕсли;
	
	// Вставка текста
	НачСтр = 0;
	НачКол = 0;
	КонСтр = 0;
	КонКол = 0;
	
	Элементы.Текст.ПолучитьГраницыВыделения(НачСтр, НачКол, КонСтр, КонКол);
	Элементы.Текст.ВыделенныйТекст = ТекстФразы;
	Элементы.Текст.ОбновитьТекстРедактирования(); // Требуется начиная с 8.3.8 для работоспособности УстановитьГраницыВыделения().
	
	// Установка курсора в продолжение выделенного текста
	ТекстовыйДок = Новый ТекстовыйДокумент;
	ТекстовыйДок.УстановитьТекст(ТекстФразы);
	КолСтрок = СтрЧислоВхождений(ТекстФразы, Символы.ПС) + 1;
	Если КолСтрок = 1 Тогда
		ДлинаКуска = СтрДлина(ТекстФразы);
		Элементы.Текст.УстановитьГраницыВыделения(НачСтр, НачКол + ДлинаКуска, КонСтр, НачКол + ДлинаКуска);
	Иначе
		ДлинаПослСтроки = СтрДлина(ТекстовыйДок.ПолучитьСтроку(КолСтрок)) + 1;
		Элементы.Текст.УстановитьГраницыВыделения(НачСтр + КолСтрок - 1, ДлинаПослСтроки, КонСтр + КолСтрок - 1, ДлинаПослСтроки);
	КонецЕсли;
 	
 	ЭтаФорма.ТекущийЭлемент = Элементы.Текст;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстФразы(Ссылка)
	
	ТекстФразы = "";
	
	Пока ЗначениеЗаполнено(Ссылка) Цикл
		
		ТекстФразы = Ссылка.Текст + " " + ТекстФразы;
		
		Ссылка = Ссылка.Родитель;
			
	КонецЦикла; 
	
	Возврат ТекстФразы;
	
КонецФункции

&НаКлиенте
Процедура КомандаСохранитьЗакрыть(Команда)
	
	ЭтаФорма.Закрыть(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ФразыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТекущийРодитель = ?(Элементы.Фразы.Отображение = ОтображениеТаблицы.Дерево, Элементы.Фразы.ТекущаяСтрока, Элементы.Фразы.ТекущийРодитель);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения",Новый Структура("Параметр, Родитель", Параметр, ТекущийРодитель));
	ОткрытьФорму("Справочник.СоставныеФразы.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗначенийВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекстФразы = Строка(ДеревоЗначенийВыбора.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение);
	ПодставитьВыбранныйТекст(ТекстФразы);
КонецПроцедуры

&НаКлиенте
Процедура СкрытьВершиныДерева(Команда)
	Индекс = 0;
	ЭлементДерева = ДеревоЗначенийВыбора.НайтиПоИдентификатору(Индекс);
	Пока ЭлементДерева <> Неопределено Цикл
		Индекс = Индекс + 1;
		ЭлементДерева = ДеревоЗначенийВыбора.НайтиПоИдентификатору(Индекс);			
	КонецЦикла; 
	
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Элементы.ДеревоЗначенийВыбора.Свернуть(Индекс);	
	КонецЦикла; 

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВершиныДерева(Команда)
	Индекс = 0;
	ЭлементДерева = ДеревоЗначенийВыбора.НайтиПоИдентификатору(Индекс);
	Пока ЭлементДерева <> Неопределено Цикл
		Элементы.ДеревоЗначенийВыбора.Развернуть(Индекс);
		Индекс = Индекс + 1;
		ЭлементДерева = ДеревоЗначенийВыбора.НайтиПоИдентификатору(Индекс);	
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
