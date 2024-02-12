//------------------------------------------------------------------------------
// СПЕЦИФИКАЦИЯ ПАРАМЕТРОВ ПЕРЕДАВАЕМЫХ В ФОРМУ
//
// УчетнаяЗапись*  - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//
// ВОЗВРАЩАЕМОЕ ЗНАЧЕНИЕ
//
// Неопределено - пользователь отказался от ввода пароля
// Структура  - 
//            ключ "Статус", булево - истина или ложь в зависмости от успеха вызова
//            ключ "Пароль", строка - в случае если статус Истина содержит пароль
//            ключ "СообщениеОбОшибке" - в случае если статус Истина содержит текст
//                                       сообщения об ошибке
//
//------------------------------------------------------------------------------
// СПЕЦИФИКАЦИЯ ФУНКЦИОНИРОВАНИЯ ФОРМЫ
//
//   Если в списке переданных учетных записей более одной записи, то на форме
// появится возможность выбора учетной записи, с которой будет отправлено
// электронное сообщение.
//
//------------------------------------------------------------------------------

#Область ОбработчикиСобытийЭлементовФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.УчетнаяЗапись.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	Результат = ЗагрузитьПароль();
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Пароль = Результат;
		ПодтверждениеПароля = Результат;
		СохранятьПароль = Истина;
	Иначе
		Пароль = "";
		ПодтверждениеПароля = "";
		СохранятьПароль = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		Элементы.СохранятьПароль.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПарольИПродолжитьВыполнить()
	
	Если Пароль <> ПодтверждениеПароля Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Пароль и подтверждение пароля не совпадают'"), , "Пароль");
		Возврат;
	КонецЕсли;
	
	Если СохранятьПароль Тогда
		СохранитьПароль(Пароль);
	Иначе
		СохранитьПароль(Неопределено);
	КонецЕсли;
	
	Закрыть(Пароль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьПароль(Значение)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ФормаПодтвержденияПароляУчетнойЗаписи",
		УчетнаяЗапись,
		Значение
	);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьПароль()
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ФормаПодтвержденияПароляУчетнойЗаписи", УчетнаяЗапись);
	
КонецФункции

#КонецОбласти
