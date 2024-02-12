
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИдентификаторыКассы = ПолучитьИдентификаторыКасс();
	
	Если ИдентификаторыКассы.Количество() = 0 Тогда
		ТекстОшибки = "В базе нет ни одного способа оплаты ЭС НСПК с заполненным кодом кассы";
		ПоказатьПредупреждение(,ТекстОшибки);
	ИначеЕсли ИдентификаторыКассы.Количество() = 1 Тогда
		ВыборСпособаОплаты_Завершение(ИдентификаторыКассы[0], Неопределено);		
	Иначе
		ПараметрыФормы = Новый Структура("ИдентификаторыКассы", ИдентификаторыКассы);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Тип", ПредопределенноеЗначение("Перечисление.ТипыСпособовОплат.СертификатНСПК")));
		Оповещение = Новый ОписаниеОповещения("ВыборСпособаОплаты_Завершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.ЭквайринговыеТерминалы.Форма.ФормаВыбораОбычная", ПараметрыФормы,ЭтотОбъект,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборСпособаОплаты_Завершение(Результат, ДополнительныеПараметры)
	
	Если Результат <> Неопределено Тогда
		ЭТ = ОбщегоНазначенияСервер.ПолучитьРеквизитыСсылки(Результат);
		ПараметрыОперации = ЭлектронныеСертификатыНСПККлиентСервер.ПараметрыОперацииНСПК();
		ПараметрыОперации.АдресСервера = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("АдресСервисаНСПК");
		ПараметрыОперации.ИдентификаторКассы = ЭТ.ИдентификаторНСПК;
		ПараметрыОперации.КлючДоступа = ЭТ.КлючОрганизацииНСПК;
		ПараметрыОперации.КлючКассы = ЭТ.КлючКассыНСПК;
		ПараметрыОперации.ИдентификаторЗапроса = "0";
		
		Оповещение = Новый ОписаниеОповещения("ТестовоеПодключение_Завершение", ЭтотОбъект);
		ЭлектронныеСертификатыНСПККлиент.НачатьТестовоеПодключение(Оповещение, ПараметрыОперации);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестовоеПодключение_Завершение(Результат, ДополнительныеПараметры)
	
	Если Результат.Результат Тогда
		ПоказатьПредупреждение(,"Проверка связи прошла успешно!");
	Иначе
		ТекстОшибкиОбщее = 	"Ошибка при проверке связи в терминале:";
		ТекстОшибкиПодробно = Новый ФорматированнаяСтрока(Результат.ОписаниеОшибки, Новый Шрифт(,,,Истина));
		
		ФорматированныйТекстОшибки = Новый ФорматированнаяСтрока(ТекстОшибкиОбщее, Символы.ПС, ТекстОшибкиПодробно);
		ПоказатьПредупреждение(,ФорматированныйТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИдентификаторыКасс()
	
	Массив = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЭквайринговыеТерминалы.Ссылка КАК Ссылка,
	               |	ЭквайринговыеТерминалы.ИдентификаторНСПК КАК ИдентификаторНСПК
	               |ИЗ
	               |	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	               |ГДЕ
	               |	ЭквайринговыеТерминалы.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыСпособовОплат.СертификатНСПК)
	               |	И НЕ ЭквайринговыеТерминалы.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ИдентификаторНСПК) Тогда
			Массив.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции
