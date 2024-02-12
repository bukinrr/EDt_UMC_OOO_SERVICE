#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДанныеЗаполнения.Свойство("ДокументОснование", Заказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заказ) Тогда
		Документы.ВыполнениеЗаказа.ЗаполнитьМатериалыПоНормам(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента, ТаблицаПоТоварам;
	// Заголовок для сообщений об ошибках проведения.
	ТекстПроведение = НСтр("ru='Проведение документа'");
	Заголовок = ТекстПроведение + " """ + СокрЛП(Ссылка) + """: ";
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура;
	
	Если Материалы.Количество() > 0 Тогда     
		СтруктураОбязательныхПолей.Вставить("Склад");
		СтруктураОбязательныхПолей.Вставить("Ответственный");
		ПроведениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	КонецЕсли;
	
	// Проверить заполнение ТЧ .
	ПроверитьЗаполнениеТабличнойЧастиТоварыНаСкладах(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам);
	
	ПроверитьОчередностьСтатусовПоЗаказу(Отказ);	
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет шапку документа настройками сотрудника
//
Процедура ЗаполнитьДокументНастройкамиМастераПоУмолчанию() Экспорт
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если ЗначениеЗаполнено(ТекПользователь) И ЗначениеЗаполнено(ТекПользователь.Сотрудник) Тогда
		
		ЗначениеНастройки	= УправлениеНастройками.ПолучитьЗначениеСотрудникаПоУмолчанию(ТекПользователь.Сотрудник, "ОсновнойСкладТоваров");
		Склад				= ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Склад);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьОчередностьСтатусовПоЗаказу(Отказ)
	
	ДанныеСостоянияЗаказа = УправлениеЗаказами.ПолучитьСостояниеЗаказа(Заказ, ?(ЗначениеЗаполнено(Дата),Дата, ТекущаяДата()));

	Если ДанныеСостоянияЗаказа.Состояние = Справочники.ВидыСостоянийЗаказов.УКлиента Тогда
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Нельзя провести этот документ с датой позднее, чем %1, когда исходный заказ получил статус ""У клиента"".'"),
							Формат(ДанныеСостоянияЗаказа.Период, "ДЛФ=DT"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиТоварыНаСкладах(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)
	ИмяТабличнойЧасти = "Материалы";
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Количество");
	
	//// Склад в ТЧ всегда должен быть заполнен, иначе проведение будет неправильным.
	//СтруктураОбязательныхПолей.Вставить("Склад");
	
	// Теперь позовем общую процедуру проверки.
	ПроведениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Материалы", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Проверка на наличие услуг в т.ч. товаров
	РаботаСДокументамиСервер.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Материалы", ТаблицаПоТоварам, Отказ, Заголовок);
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам) 
	
	// Получим необходимые данные для проведения и проверки заполенения данных по табличной части "Материалы".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"                       , "Номенклатура");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры"         , "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("Количество"                         , "Количество");
	СтруктураПолей.Вставить("Склад"                              , "Склад");
	СтруктураПолей.Вставить("НомерСтроки"                        , "НомерСтроки");
	
	РезультатЗапросаПоТоварам = ПроведениеДокументов.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Материалы", СтруктураПолей);
	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = РезультатЗапросаПоТоварам.Выгрузить();
	
	Для Каждого СтрокаТовар Из ТаблицаПоТоварам Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовар.Склад) Тогда
			СтрокаТовар.Склад = СтруктураШапкиДокумента.Склад;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПодготовитьТаблицыДокумента()

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок); 
	ПартионныйУчет.пуДвижениеПартийТоваров(Ссылка, Движения.СписанныеТовары.Выгрузить(), Отказ);
    	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок) 
	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.
	НаборДвижений = Движения.СписанныеТовары;
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);
	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;
	ТаблицаДвижений.ЗаполнитьЗначения(Дата,   "Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка, "Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;
КонецПроцедуры // ДвиженияПоРегистрамУпр()

#КонецОбласти