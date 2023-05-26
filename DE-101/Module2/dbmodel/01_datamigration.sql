--	ship_modes

INSERT INTO ship_modes
SELECT DISTINCT ship_mode
FROM orders_old
;

--	products

-- find product_id duplicates and fix data

/*
SELECT product_id, COUNT(*)
FROM (
	SELECT DISTINCT product_id, product_name
	FROM orders_old
	GROUP BY product_id, product_name 
	ORDER BY product_id
	) AS o
GROUP BY product_id
HAVING COUNT(*) > 1
;
*/


UPDATE orders_old
SET product_id = 'FUR-BO-10002218'
WHERE product_name = 'DMI Eclipse Executive Suite Bookcases';

UPDATE orders_old
SET product_id = 'FUR-CH-10001147'
WHERE product_name = 'Global Task Chair, Black';

UPDATE orders_old
SET product_id = 'FUR-FU-10001476'
WHERE product_name = 'DAX Wood Document Frame';

UPDATE orders_old
SET product_id = 'FUR-FU-10004317'
WHERE product_name = 'Executive Impressions 13" Chairman Wall Clock';

UPDATE orders_old
SET product_id = 'FUR-FU-10004291'
WHERE product_name = 'Howard Miller 13" Diameter Goldtone Round Wall Clock';

UPDATE orders_old
SET product_id = 'FUR-FU-10004280'
WHERE product_name = 'Executive Impressions 13" Clairmont Wall Clock';

UPDATE orders_old
SET product_id = 'FUR-FU-10004858'
WHERE product_name = 'Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock';

UPDATE orders_old
SET product_id = 'FUR-FU-10004866'
WHERE product_name = 'Howard Miller 14-1/2" Diameter Chrome Round Wall Clock';

--

UPDATE orders_old
SET product_id = 'OFF-AP-10005576'
WHERE product_name = 'Belkin 7 Outlet SurgeMaster II';

UPDATE orders_old
SET product_id = 'OFF-AR-10001249'
WHERE product_name = 'Avery Hi-Liter Comfort Grip Fluorescent Highlighter, Yellow Ink';

UPDATE orders_old
SET product_id = 'OFF-BI-10002226'
WHERE product_name = 'Avery Arch Ring Binders';

UPDATE orders_old
SET product_id = 'OFF-BI-10004642'
WHERE product_name = 'Ibico Hi-Tech Manual Binding System';

UPDATE orders_old
SET product_id = 'OFF-BI-10004655'
WHERE product_name = 'Avery Binding System Hidden Tab Executive Style Index Sets';

UPDATE orders_old
SET product_id = 'OFF-PA-10003357'
WHERE product_name = 'Xerox 1888';

UPDATE orders_old
SET product_id = 'OFF-PA-10002477'
WHERE product_name = 'Xerox 1952';

UPDATE orders_old
SET product_id = 'OFF-PA-10001659'
WHERE product_name = 'TOPS Carbonless Receipt Book, Four 2-3/4 x 7-1/4 Money Receipts per Page';

UPDATE orders_old
SET product_id = 'OFF-PA-10001266'
WHERE product_name = 'Xerox 2';

UPDATE orders_old
SET product_id = 'OFF-PA-10001971'
WHERE product_name = 'Xerox 1908';

UPDATE orders_old
SET product_id = 'OFF-PA-10002795'
WHERE product_name = 'Xerox 1966';

UPDATE orders_old
SET product_id = 'OFF-PA-10002370'
WHERE product_name = 'Xerox 1916';

UPDATE orders_old
SET product_id = 'OFF-PA-10003822'
WHERE product_name = 'Xerox 1992';

UPDATE orders_old
SET product_id = 'OFF-ST-10001227'
WHERE product_name = 'Fellowes Personal Hanging Folder Files, Navy';

UPDATE orders_old
SET product_id = 'OFF-ST-10004953'
WHERE product_name = 'Acco Perma 3000 Stacking Storage Drawers';

--

UPDATE orders_old
SET product_id = 'TEC-AC-10002047'
WHERE product_name = 'Logitech G19 Programmable Gaming Keyboard';

UPDATE orders_old
SET product_id = 'TEC-AC-10002551'
WHERE product_name = 'Memorex 25GB 6X Branded Blu-Ray Recordable Disc, 30/Pack';

UPDATE orders_old
SET product_id = 'TEC-AC-10008832'
WHERE product_name = 'Logitech P710e Mobile Speakerphone';

UPDATE orders_old
SET product_id = 'TEC-MA-10005148'
WHERE product_name = 'Okidata MB491 Multifunction Printer';

UPDATE orders_old
SET product_id = 'TEC-PH-10001539'
WHERE product_name = 'Plantronics Voyager Pro Legend';

UPDATE orders_old
SET product_id = 'TEC-PH-10001792'
WHERE product_name = 'ClearOne CHATAttach 160 - speaker phone';

UPDATE orders_old
SET product_id = 'TEC-PH-10002222'
WHERE product_name = 'Aastra 6757i CT Wireless VoIP phone';

UPDATE orders_old
SET product_id = 'TEC-PH-10002318'
WHERE product_name = 'Panasonic KX T7731-B Digital phone';

UPDATE orders_old
SET product_id = 'TEC-PH-10004551'
WHERE product_name = 'AT&T CL2909';


INSERT INTO products
SELECT DISTINCT product_id, category, subcategory, product_name
FROM orders_old
;






