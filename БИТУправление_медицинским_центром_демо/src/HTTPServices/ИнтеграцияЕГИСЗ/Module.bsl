#Область СлужебныеПроцедурыИФункции

Функция EmdrCallBackPOST(Запрос)
	Ответ = ИнтеграцияЕГИСЗСервер.ОбработатьЗапросHTTPСервиса(Запрос);
	Возврат Ответ;
КонецФункции

Функция EmdrCallBackGET(Запрос)
	Ответ = ИнтеграцияЕГИСЗСервер.ОбработатьЗапросHTTPСервиса(Запрос);
	Возврат Ответ;
КонецФункции

#КонецОбласти