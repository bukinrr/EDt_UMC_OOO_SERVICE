
#Область ОбработчикиСобытий

// Процедура вызывается перед записью в регистр.
//
Процедура ПередЗаписью(Отказ, Замещение = Истина)

	Для каждого Запись Из ЭтотОбъект Цикл
		Запись.ГраницаЗапретаИзменений = КонецДня(Запись.ГраницаЗапретаИзменений);
	КонецЦикла;
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти
