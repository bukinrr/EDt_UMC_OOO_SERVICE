#Область ПрограммныйИнтерфейс

// Аллергические реакции пациента
//
// Параметры:
//  Клиент	 - СправочникСсылка.Клиенты	 - клиент.
//  КодыАТХ	 - Массив					 - коды АТХ.
// 
// Возвращаемое значение:
//  Массив - коды АТХ.
//
Функция ПолучитьНепереносимыеАТХ(Клиент, КодыАТХЛС) Экспорт
	
	НепереносимыеВещества = Новый Соответствие;
	
	НаборЗаписей = РегистрыСведений.ЛекарственнаяНепереносимость.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Клиент.Установить(Клиент);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() <> 0 Тогда
		ДействующиеВещества = НаборЗаписей.ВыгрузитьКолонку("ДействующееВещество");
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДействующиеВеществаЛекарственныхПрепаратов.КодАТХ КАК КодАТХ,
		|	ДействующиеВеществаЛекарственныхПрепаратов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДействующиеВеществаЛекарственныхПрепаратов КАК ДействующиеВеществаЛекарственныхПрепаратов
		|ГДЕ
		|	ДействующиеВеществаЛекарственныхПрепаратов.Ссылка В(&ДействующиеВещества)";
		
		Запрос.УстановитьПараметр("ДействующиеВещества", ДействующиеВещества);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			КодыАТХДВ = СтрРазделить(Выборка.КодАТХ, "; ", Ложь);
			Для Каждого КодАТХЛС Из КодыАТХЛС Цикл
				Если КодыАТХДВ.Найти(КодАТХЛС) <> Неопределено Тогда
					Если НепереносимыеВещества.Получить(Выборка.Ссылка) = Неопределено Тогда
						НепереносимыеВещества.Вставить(Выборка.Ссылка, Новый Массив);
					КонецЕсли;
					НепереносимыеВещества.Получить(Выборка.Ссылка).Добавить(КодАТХЛС);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат НепереносимыеВещества;
	
КонецФункции

// Это наркотический препарат
//
// Параметры:
//  Препарат - СправочникСсылка.Номенклатура, СправочникСсылка.СправочникМеждународныхНепатентованныхНаименований - проверяемый препарат
// 
// Возвращаемое значение:
//  Булево - Истина, если наркотический.
//
Функция ГруппыПрепарата(Препарат) Экспорт
	
	Результат = Новый Структура("ЖНВЛС, Наркотическое", Ложь, Ложь);
	
	ЭтоНаркотический = Ложь;
	
	Если ТипЗнч(Препарат) = Тип("СправочникСсылка.СправочникМеждународныхНепатентованныхНаименований") Тогда
		Результат.Наркотическое = Препарат.Наркотическое;
		Результат.ЖНВЛС = Препарат.ЖНВЛС;
		
	ИначеЕсли ТипЗнч(Препарат) = Тип("СправочникСсылка.Номенклатура") Тогда
		Результат.Наркотическое	= ЗначениеЗаполнено(Препарат.NARCO)
								И Препарат.NARCO <> Перечисления.СпискиНаркотическихВеществ.НеВключен
								И Препарат.NARCO <> Ложь;
								
		Результат.ЖНВЛС = ЗначениеЗаполнено(Препарат.JNVLS)
						И Препарат.NARCO <> Перечисления.СпискиЖНиВЛП.НеВключен
						И Препарат.NARCO <> Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти