--
-- E-commerce Data Pipeline Database Export
-- Generated on: 2025-08-02 00:37:23
-- 


-- Table: categories
-- ================================================

DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    id INTEGER NOT NULL DEFAULT nextval('categories_id_seq'::regclass),
    name CHARACTER VARYING,
    description TEXT,
    parent_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Data for table categories (25 records)
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (1, 'Fiction', 'Score each cause. Quality throughout beautiful instead.
Despite measure ago current.
Determine operation speak according south recently. Everyone democratic shake bill here grow. Page southern role movie win her.
Stop peace technology officer relate. Product significant world. Term herself law street class.
Prove reduce raise author play. Rock clear here writer policy news range. Director allow firm environment.
Then fire pretty how trip learn enter. Seat much section investment on.', NULL, True, 2025-04-23 12:50:53);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (2, 'Comics', 'Shoulder future fall citizen about. Will seven medical blood personal. Participant check several much single morning a.
Affect upon these story film around there. Beat magazine attorney set. Campaign little near enter.
Who up sense ready require human. Just military building different full open. Open according remain arrive attack. Teacher audience draw.
Much rich think office drug. Space couple best issue interest level rock. Art rock song body.', NULL, False, 2025-06-22 11:11:19);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (3, 'Automotive', 'Unit support coach magazine.
Total clearly able hospital unit size. Institution whatever yet new responsibility.
Father why often my security. Anyone live try most.
Bag control organization push dog build three. Often always bank price north.
Daughter respond draw how public. Lead upon very act perform. You available defense enter value thing these.
Citizen street region particularly would. Account stage federal professional voice care break. Score choice example decision.', NULL, True, 2025-05-16 15:37:11);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (4, 'Home & Garden', 'Relationship night born war real chance along. Old challenge camera final together someone. Together decide economic.
Sister this image per choice upon. Wish specific thing agent.
Soon ten specific environment skin blue. Teach develop staff. Glass star the development process huge everything.
Go meeting quickly such former. Boy wife condition.
Board its rock. Job worker break tonight couple and.
Mind southern rather. Hair attorney professional form finish. Rest feel finally impact.', 3, False, 2024-10-23 18:41:18);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (5, 'Books', 'Soldier where save probably exist professional people. Stand seem pull different. Challenge animal worker particularly shoulder.
Though offer responsibility himself hundred challenge. Throughout team those. Despite sound receive let newspaper true.
Card let most next fish sense kind. Interview trade knowledge city technology late seem.
Machine dream key require doctor from throw. Catch discuss really relationship.', 1, False, 2025-02-26 19:25:34);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (6, 'Electronics', 'Today major event magazine home protect something right. Try wonder move trade option production base. Career left anyone here deep force.
Sell story edge bank affect. Appear weight difference attention whatever American all. Current after charge call prove.
Let eight hard paper white. Sing clearly find official. Office traditional heart walk cup.', NULL, False, 2024-11-14 00:28:28);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (7, 'Women''s Clothing', 'Store beautiful think during let. Property from management foot maintain great election evidence. Red everybody act way beat result major serve.
Large admit family identify during professional hard. Most international second former reflect even edge. Return firm sea week.
Describe machine right with modern. Wonder strategy fast guess few.
Ever window network recently. Point sell bill activity. Light key continue anything wait.', 5, False, 2024-10-28 10:24:12);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (8, 'Beauty', 'Late kind team wrong figure perform. Whether between several personal enough ball dream necessary. Able late order fact.
Religious reflect law reach under. Operation sound cup boy different chance enter central.
Society organization station TV. Buy read record wall matter management.
Always it focus economy before while structure offer. Yourself public especially.
Like prepare trouble consider.', 6, True, 2025-02-19 03:03:08);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (9, 'Kids'' Clothing', 'Series personal service data near until just recognize. Ahead picture son report. Nearly need behavior yeah tree.
Positive child usually factor. Indeed lot line lead certain. Two meet these tell everybody.
Various meet star executive fear only. Tend land machine forward several help usually. Wonder draw him task improve.
Relate specific history professional star wonder manager. Call whole forward. Them key moment lead.
That wide avoid sit enter perhaps. Power system system teacher here first.', 8, True, 2024-11-04 14:55:55);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (10, 'Shoes', 'Not society color bad that people. Marriage on discussion point least. Together let explain.
Available war write federal. Real lead few yourself table blood. Occur offer yeah far within probably.
Not rate seat. Treat seat strategy.
Parent good PM per question. Pick tough position final.
Often run bed. Force indeed customer skill theory. Most tree store either station loss.
Sound life away senior difficult put. Whose source hand so add Mr.', NULL, True, 2024-09-25 01:39:47);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (11, 'Bathroom', 'Fight manage best.
Home he we recent. Industry score choice increase between majority impact. Allow have kitchen wear talk.
Name within grow huge couple business. Begin deep police wife anything four writer.
Attention share debate democratic thank. Similar small other everyone worker would. Economy company produce ago address so draw.
Company appear score. Box as large gun order later develop. Analysis situation term miss leader who article look.', NULL, False, 2025-04-11 13:49:47);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (12, 'Furniture', 'Involve thousand including still human. Fine fine effort well. Attack story behavior benefit school speech news.
No prove improve them wait institution trouble. Why outside goal. Medical choice lot suggest glass news boy. Off southern suddenly window stand.
Ago upon stop environment Congress reflect finally. Go consider century price attorney scientist. Begin most heavy. Game have return since nothing be apply.', NULL, False, 2025-03-22 12:57:37);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (13, 'Gaming', 'Daughter war should. Face build market issue can.
Matter street south author technology. Job least back. Office of remember individual boy again.
Soon peace story turn. Join black job hundred. How financial fund four.
Member box member town. Go when population challenge bill eight.
Check service away week physical less nor often. Poor worry follow wife firm key light.
Someone option goal avoid left. Arm story baby. Past medical leg never. Last special prepare.', 3, True, 2024-12-07 19:47:15);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (14, 'Magazines', 'Question exist rich prevent trade their four. Professional true financial prevent product can remember be.
Poor foreign campaign reflect water young. Behavior provide meet adult final week game. Court yourself choice fast small medical music.
Product then peace. Heavy class story side speak close join improve. Wide particular sell six doctor.
Whole six tough create question. Worker left example high month whom stage.', 2, True, 2024-11-01 08:27:28);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (15, 'Tablets', 'Heart agreement us stuff. Social case expert stop receive catch. Large accept bad eight strong nature road.
Book explain feeling answer information soldier. Artist student matter movie place offer responsibility. Investment pass drive indicate professor.
Window attack moment medical write never hospital. Analysis hit health section ground attack drop.
Sign same forward and. Full poor store range wonder long consider. As simply leader fall. Social though firm.', NULL, True, 2025-01-18 11:31:44);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (16, 'Laptops', 'Thus hit wind many marriage under. Entire bar interesting issue yet Congress family. Bag produce fill owner.
Ready goal amount thank. Past itself police social arm provide. Guy song quickly well central parent.
Call door population. Him note painting quickly we head. Off morning huge power.
Ago control military trial. Energy employee land you.
Customer career available common require young specific. Property remember nearly face feel church.', 13, False, 2025-05-07 23:11:52);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (17, 'Clothing', 'Improve important offer by first avoid letter. General there sister policy consider whom item. Story million fight class.
Way million exist bad cultural what. By field move maybe collection.
Commercial person top front. American tell ball we side enough decision. Indicate police marriage phone face what lot. Father authority art keep machine daughter.
Fine responsibility safe team. Candidate have no five letter environment. Cell anything war ten industry. Spend value return couple.', 4, False, 2025-04-19 23:11:35);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (18, 'Decor', 'Mr suggest issue think road. Hand hundred now crime network available. Late near stay perhaps particularly campaign benefit.
Newspaper hand certain own husband American. Case four listen. Chance throw cause use five hotel pattern.
From stock mother remember feel staff happy purpose. On someone rise read ago listen.
Dinner anything lose modern return simple herself. All way body affect finish. Include data maybe particularly. Their save artist catch debate foot production.', 10, False, 2025-07-30 09:33:54);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (19, 'Kitchen', 'Business quality here woman stand. Fact explain research get.
Section degree still even no. Case past only drug prove. Difficult do beyond form line race case.
Imagine various there local. Sense expert experience arrive shoulder. Discussion school sure also TV individual study.
Small control see the face also.
Owner up friend lawyer political modern threat. Surface life cover both.
Possible responsibility add front far purpose cover. Task today still middle beautiful protect continue cell.', 12, True, 2024-10-25 21:16:24);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (20, 'Educational', 'Check security paper indeed near likely Mr. Seven quite other skin moment.
Back nor article natural measure of. Clearly take kind quite. Major together knowledge argue car indeed nor next.
How staff second. Authority interest red must art thus worry line.
Conference career political role white hear. Large true help bag who themselves.
Budget year hotel camera without strong. Without leg rest.
Here discover leave choice country themselves she. Special information she. Drive attack order.', NULL, False, 2024-10-26 15:06:52);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (21, 'Non-Fiction', 'Every news option same compare. New another general poor high modern. Impact feel contain Mrs drive different.
Trip none whose newspaper care drug data. Two suggest begin right.
Environmental purpose owner. Could seven right next.
Thank four whatever address view. Section senior trial receive. However dream focus executive letter.
End mention market better wonder. Seven floor data fine animal ten scientist. End various often.', NULL, True, 2025-02-21 06:21:46);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (22, 'Food & Beverage', 'War property share include.
Attack character despite lay art. Tree process administration mother in admit reveal movie. Admit spend purpose south travel. Truth modern drive people.
Environment however health image north wrong. Feel stock ball yard practice.
If help live PM.
Matter its six not. Thus try discover top.
Even under range exactly myself probably conference. Administration debate certain star start up. Class drive strong home to.', 8, True, 2025-03-04 13:31:55);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (23, 'Health', 'Control one herself sign far east. Bank child Republican plant. First blood accept final growth especially.
Cost large never impact. Bed never others.
Activity including single right nice yeah. Occur college herself catch feeling. Certainly cold every feel site guess want.
Order crime blood fight we forward per. Key issue statement prepare organization feel. Water cut fire who why fact reason make. Site for exactly skill half usually customer.', 12, True, 2024-08-30 12:15:07);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (24, 'Toys', 'Look husband media turn reality myself so growth. Order trial body eat professor coach partner. Worker quality hundred sell whole involve action.
Member million oil offer knowledge. Leg quickly real character young lot.
Turn beat story role give gas. Miss give best reveal laugh.
And represent against gas body. Upon scientist might necessary.', 7, False, 2025-04-06 23:46:14);
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES (25, 'Accessories', 'Home hotel box goal leader common purpose song. Opportunity public finish draw bring health center home. Case himself control player really population yourself never.
Cell fire late approach grow. Machine crime himself. Measure manager range indeed style major bar.
Factor ever Mrs collection leader.
Member of environmental myself yard my series. National wrong bill stop seem fear. Last give stage.', 18, False, 2024-11-23 10:24:00);


-- Table: order_items
-- ================================================

DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE order_items (
    id INTEGER NOT NULL DEFAULT nextval('order_items_id_seq'::regclass),
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price NUMERIC,
    total_price NUMERIC,
    discount_amount NUMERIC DEFAULT 0
);

-- Data for table order_items (500 records)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (1, 41, 224, 8, 649.52, 175.03, 4844.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (2, 178, 183, 4, 665.86, 814.63, 1898.14);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (3, 188, 151, 3, 178.53, 2.80, 3513.02);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (4, 147, 201, 10, 33.35, 602.78, 4605.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (5, 157, 114, 10, 105.01, 496.68, 1662.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (6, 20, 122, 6, 982.39, 168.72, 4427.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (7, 23, 172, 8, 12.38, 210.47, 3468.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (8, 90, 132, 2, 720.69, 49.10, 2196.72);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (9, 108, 86, 7, 493.58, 379.33, 2734.66);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (10, 26, 246, 10, 651.31, 687.47, 821.66);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (11, 19, 18, 5, 21.06, 261.86, 532.58);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (12, 88, 88, 7, 161.74, 75.93, 4709.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (13, 24, 174, 10, 985.28, 893.32, 3525.48);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (14, 111, 85, 10, 889.85, 157.95, 515.28);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (15, 53, 98, 7, 697.49, 722.31, 3652.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (16, 68, 145, 5, 238.31, 50.59, 2863.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (17, 126, 79, 1, 361.46, 428.17, 1479.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (18, 170, 246, 4, 97.89, 207.74, 3194.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (19, 21, 243, 2, 309.04, 398.07, 2450.59);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (20, 170, 136, 2, 642.22, 388.14, 1861.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (21, 98, 190, 3, 446.33, 264.03, 2330.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (22, 58, 138, 10, 62.58, 752.48, 3340.67);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (23, 22, 177, 9, 414.57, 756.69, 1145.29);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (24, 16, 199, 9, 419.21, 535.97, 4335.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (25, 122, 294, 4, 476.78, 79.88, 4514.86);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (26, 183, 18, 9, 571.64, 517.30, 2861.71);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (27, 159, 76, 2, 949.30, 449.59, 4745.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (28, 43, 109, 4, 127.06, 423.95, 4941.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (29, 112, 104, 3, 834.27, 258.63, 4554.91);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (30, 18, 45, 7, 556.80, 552.50, 4284.55);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (31, 134, 235, 1, 786.76, 623.43, 2617.58);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (32, 108, 58, 7, 150.49, 567.02, 2917.56);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (33, 26, 55, 10, 779.76, 785.95, 4338.70);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (34, 89, 211, 5, 383.66, 486.09, 3048.72);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (35, 10, 89, 5, 403.57, 618.62, 3407.26);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (36, 103, 20, 7, 889.68, 332.16, 1195.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (37, 191, 244, 5, 897.13, 21.21, 4088.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (38, 78, 160, 5, 843.00, 858.37, 3427.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (39, 59, 69, 5, 974.24, 443.66, 4130.86);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (40, 69, 214, 10, 645.90, 188.75, 1064.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (41, 105, 249, 9, 867.31, 821.19, 2581.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (42, 41, 34, 5, 709.85, 403.98, 3904.78);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (43, 135, 292, 1, 174.56, 875.30, 1011.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (44, 15, 128, 1, 456.99, 918.10, 3526.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (45, 71, 189, 8, 505.62, 635.77, 628.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (46, 8, 124, 6, 489.29, 446.65, 4803.00);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (47, 122, 283, 6, 344.90, 837.81, 1300.71);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (48, 177, 47, 5, 28.42, 50.60, 4270.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (49, 200, 110, 4, 647.73, 678.01, 1352.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (50, 105, 263, 1, 864.76, 967.16, 3414.18);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (51, 122, 68, 3, 601.53, 9.46, 1269.43);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (52, 79, 141, 7, 895.58, 851.73, 2300.40);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (53, 56, 239, 5, 677.51, 824.48, 1991.79);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (54, 27, 4, 9, 999.42, 966.51, 4198.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (55, 144, 145, 5, 684.72, 482.25, 1688.06);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (56, 71, 167, 5, 261.88, 711.38, 4462.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (57, 77, 97, 3, 517.77, 241.06, 293.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (58, 154, 207, 6, 681.07, 721.55, 3280.45);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (59, 76, 133, 7, 405.19, 736.99, 2919.29);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (60, 147, 98, 6, 726.82, 223.14, 2677.83);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (61, 122, 184, 9, 300.89, 170.81, 3291.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (62, 143, 93, 5, 98.50, 128.81, 1300.67);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (63, 144, 94, 6, 654.77, 223.03, 1124.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (64, 79, 216, 6, 372.31, 585.98, 2324.17);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (65, 31, 241, 1, 866.52, 583.99, 4722.06);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (66, 19, 242, 4, 500.97, 867.62, 1914.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (67, 77, 212, 1, 870.97, 151.63, 4961.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (68, 88, 210, 10, 892.94, 986.65, 724.69);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (69, 184, 93, 2, 488.09, 631.40, 892.35);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (70, 163, 30, 1, 452.60, 210.17, 3869.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (71, 148, 82, 8, 785.42, 779.96, 655.74);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (72, 112, 220, 7, 429.59, 477.92, 33.30);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (73, 137, 103, 6, 950.11, 892.11, 3786.67);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (74, 136, 98, 1, 677.06, 627.05, 1251.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (75, 178, 177, 5, 129.80, 384.16, 2947.47);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (76, 43, 34, 1, 298.90, 291.53, 3641.88);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (77, 153, 269, 6, 434.23, 687.09, 677.61);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (78, 126, 184, 4, 165.72, 906.98, 4061.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (79, 5, 117, 4, 727.43, 132.07, 3673.04);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (80, 151, 259, 3, 124.04, 711.39, 3962.71);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (81, 97, 131, 9, 623.51, 594.32, 249.32);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (82, 28, 11, 1, 690.05, 417.35, 1907.47);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (83, 141, 130, 8, 702.16, 206.29, 3431.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (84, 3, 155, 7, 662.00, 662.81, 1357.19);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (85, 156, 71, 7, 830.81, 105.81, 3596.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (86, 31, 145, 2, 784.97, 498.24, 3048.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (87, 200, 135, 9, 973.14, 358.56, 2054.68);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (88, 42, 21, 9, 496.85, 208.48, 4666.29);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (89, 85, 121, 1, 13.74, 89.91, 561.05);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (90, 147, 253, 3, 949.49, 779.74, 384.49);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (91, 186, 52, 5, 644.69, 457.29, 4886.68);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (92, 68, 238, 1, 100.71, 175.53, 206.83);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (93, 75, 185, 6, 426.56, 116.78, 4257.72);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (94, 12, 5, 3, 663.69, 171.34, 1794.06);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (95, 113, 138, 2, 373.25, 343.38, 578.02);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (96, 103, 234, 5, 835.86, 690.21, 2396.44);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (97, 108, 86, 2, 133.38, 726.68, 4908.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (98, 41, 54, 7, 911.31, 483.19, 2849.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (99, 113, 93, 10, 380.37, 359.24, 153.79);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (100, 176, 67, 8, 920.47, 113.82, 2062.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (101, 12, 33, 5, 655.31, 13.35, 4342.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (102, 135, 296, 10, 224.76, 955.80, 4366.99);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (103, 133, 268, 10, 96.15, 662.04, 1250.40);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (104, 89, 198, 3, 839.19, 558.78, 4939.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (105, 14, 6, 3, 506.06, 469.81, 2484.22);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (106, 43, 39, 8, 321.31, 331.56, 1398.00);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (107, 130, 115, 9, 643.67, 403.87, 1182.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (108, 118, 228, 10, 448.65, 856.72, 2240.87);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (109, 31, 255, 1, 103.54, 412.92, 2790.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (110, 1, 47, 10, 963.20, 637.89, 4451.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (111, 144, 106, 8, 950.40, 363.98, 280.83);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (112, 58, 233, 6, 560.59, 620.13, 2370.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (113, 169, 187, 8, 114.91, 759.55, 1116.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (114, 88, 182, 5, 548.14, 374.51, 540.55);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (115, 43, 253, 3, 822.01, 742.76, 2051.96);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (116, 66, 101, 4, 121.62, 852.33, 1085.79);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (117, 49, 174, 2, 757.38, 47.45, 3169.87);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (118, 173, 64, 8, 457.93, 589.72, 2525.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (119, 128, 3, 9, 736.47, 553.67, 2169.72);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (120, 150, 248, 9, 781.29, 910.26, 3462.17);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (121, 45, 66, 2, 388.01, 600.94, 4414.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (122, 130, 197, 7, 979.51, 915.99, 3814.25);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (123, 71, 204, 6, 970.51, 453.39, 675.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (124, 106, 263, 5, 843.22, 548.25, 1576.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (125, 189, 284, 4, 201.69, 624.54, 1459.99);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (126, 89, 68, 3, 504.38, 694.61, 1618.68);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (127, 30, 181, 9, 480.88, 571.06, 3339.11);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (128, 107, 274, 5, 877.59, 422.96, 73.72);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (129, 28, 13, 7, 146.18, 670.58, 1007.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (130, 193, 83, 5, 683.70, 147.28, 319.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (131, 76, 105, 9, 33.27, 814.20, 521.38);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (132, 173, 288, 4, 742.66, 561.70, 1195.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (133, 179, 148, 1, 926.55, 388.16, 4783.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (134, 176, 161, 9, 54.75, 743.92, 1023.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (135, 200, 227, 4, 911.57, 704.92, 3241.69);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (136, 194, 280, 10, 197.27, 725.18, 975.55);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (137, 115, 91, 2, 187.79, 174.62, 2574.10);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (138, 97, 21, 7, 279.83, 264.97, 813.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (139, 66, 3, 6, 466.86, 937.55, 209.30);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (140, 83, 27, 10, 843.29, 301.85, 3951.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (141, 141, 184, 2, 784.24, 318.54, 1107.61);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (142, 48, 267, 2, 786.46, 160.21, 2719.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (143, 104, 48, 6, 221.97, 214.14, 1666.10);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (144, 93, 151, 4, 950.35, 618.66, 2379.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (145, 144, 5, 2, 669.26, 446.22, 4523.44);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (146, 158, 125, 1, 682.86, 321.61, 4580.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (147, 30, 198, 5, 540.69, 283.54, 4557.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (148, 198, 192, 9, 803.01, 446.11, 228.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (149, 167, 99, 6, 514.38, 948.25, 845.30);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (150, 198, 276, 9, 8.32, 66.41, 3354.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (151, 199, 110, 7, 835.82, 206.37, 4145.46);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (152, 190, 223, 2, 747.14, 154.60, 2301.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (153, 85, 20, 2, 74.17, 178.81, 1267.02);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (154, 19, 295, 4, 911.07, 408.22, 2261.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (155, 104, 222, 6, 17.87, 673.62, 2678.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (156, 165, 33, 10, 46.47, 848.39, 1794.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (157, 129, 55, 5, 787.10, 302.05, 441.66);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (158, 196, 225, 7, 395.71, 661.06, 2375.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (159, 137, 113, 3, 747.00, 796.97, 4248.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (160, 76, 74, 5, 677.60, 914.25, 3977.14);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (161, 187, 192, 1, 553.97, 555.51, 624.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (162, 2, 294, 10, 394.68, 547.97, 434.78);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (163, 54, 177, 4, 413.24, 646.28, 2567.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (164, 42, 95, 4, 617.26, 253.49, 581.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (165, 172, 291, 1, 851.53, 932.43, 4971.62);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (166, 119, 282, 2, 291.36, 68.29, 500.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (167, 186, 298, 8, 951.58, 357.78, 3359.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (168, 61, 52, 5, 619.89, 900.21, 1595.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (169, 116, 169, 10, 659.76, 693.76, 770.45);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (170, 146, 187, 6, 958.69, 169.47, 1572.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (171, 57, 224, 5, 840.26, 135.17, 3667.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (172, 123, 237, 8, 359.38, 306.16, 2762.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (173, 45, 42, 5, 858.85, 140.86, 2697.70);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (174, 68, 40, 2, 892.20, 849.73, 3161.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (175, 149, 297, 7, 769.42, 213.55, 192.91);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (176, 67, 279, 9, 472.63, 775.41, 1835.43);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (177, 58, 149, 3, 465.23, 510.90, 1989.96);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (178, 129, 6, 4, 848.13, 806.73, 3074.04);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (179, 43, 264, 3, 446.77, 179.96, 4744.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (180, 169, 75, 8, 939.23, 41.38, 3809.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (181, 60, 33, 5, 370.06, 43.77, 1041.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (182, 93, 199, 8, 917.97, 881.66, 209.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (183, 167, 166, 2, 704.03, 521.85, 4149.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (184, 190, 135, 10, 544.80, 174.67, 3271.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (185, 94, 40, 9, 252.33, 972.69, 1122.27);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (186, 104, 181, 6, 487.37, 482.62, 3025.01);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (187, 129, 72, 8, 166.44, 78.01, 3220.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (188, 55, 77, 3, 158.20, 602.41, 4086.61);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (189, 170, 118, 7, 811.35, 720.53, 2412.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (190, 123, 246, 4, 591.19, 647.61, 2060.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (191, 63, 23, 3, 573.91, 161.97, 3151.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (192, 11, 294, 3, 56.86, 259.00, 908.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (193, 104, 289, 1, 878.62, 728.24, 4108.30);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (194, 22, 111, 8, 606.91, 471.94, 2413.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (195, 57, 211, 10, 143.57, 583.06, 3839.78);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (196, 160, 262, 5, 168.55, 685.90, 4612.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (197, 153, 36, 4, 378.83, 133.08, 92.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (198, 134, 259, 7, 826.68, 605.90, 895.34);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (199, 158, 20, 9, 503.82, 118.40, 2416.38);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (200, 34, 277, 1, 897.06, 775.09, 3249.67);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (201, 134, 216, 6, 874.94, 697.94, 2150.49);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (202, 124, 196, 6, 589.45, 741.65, 3810.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (203, 179, 295, 2, 426.06, 255.26, 3831.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (204, 22, 146, 10, 876.88, 409.23, 953.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (205, 182, 4, 10, 523.01, 520.24, 1881.40);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (206, 53, 162, 7, 362.90, 155.62, 3261.36);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (207, 65, 134, 9, 424.13, 366.27, 1385.05);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (208, 175, 204, 4, 413.81, 784.00, 2417.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (209, 95, 287, 9, 484.27, 988.51, 2892.48);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (210, 199, 204, 3, 855.14, 659.62, 3741.59);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (211, 115, 83, 2, 215.24, 401.16, 1698.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (212, 141, 27, 3, 389.71, 636.23, 4023.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (213, 38, 242, 10, 435.94, 65.02, 1116.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (214, 21, 20, 7, 930.74, 401.24, 3284.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (215, 74, 30, 3, 640.64, 439.53, 1016.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (216, 169, 266, 5, 195.55, 784.17, 2557.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (217, 179, 119, 10, 170.31, 37.02, 1203.89);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (218, 1, 81, 2, 996.81, 779.89, 1772.11);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (219, 102, 208, 10, 201.11, 16.35, 3521.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (220, 24, 282, 5, 726.41, 559.55, 2918.83);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (221, 89, 142, 4, 606.75, 195.33, 4649.27);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (222, 148, 3, 5, 175.86, 506.73, 2797.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (223, 129, 151, 6, 947.06, 803.13, 4783.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (224, 138, 295, 5, 694.49, 966.08, 2820.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (225, 198, 125, 6, 961.27, 459.38, 2309.00);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (226, 151, 15, 8, 117.15, 68.49, 3171.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (227, 57, 118, 6, 413.01, 353.74, 2682.90);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (228, 180, 135, 4, 288.00, 399.53, 3746.45);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (229, 88, 39, 9, 931.46, 477.07, 1774.15);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (230, 147, 138, 3, 947.16, 683.42, 4550.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (231, 128, 103, 4, 735.69, 872.86, 1041.83);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (232, 52, 128, 10, 356.67, 779.15, 608.19);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (233, 21, 253, 10, 7.62, 857.22, 4790.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (234, 124, 191, 10, 316.10, 898.21, 4406.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (235, 148, 141, 8, 183.69, 764.49, 2560.56);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (236, 102, 114, 10, 129.12, 526.20, 2121.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (237, 139, 17, 9, 347.94, 860.53, 3881.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (238, 118, 62, 9, 460.61, 689.51, 68.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (239, 54, 195, 10, 101.65, 362.24, 4310.59);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (240, 48, 281, 5, 237.90, 471.87, 3069.29);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (241, 94, 95, 8, 424.51, 419.67, 3763.46);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (242, 94, 206, 5, 451.27, 571.83, 4896.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (243, 176, 118, 2, 721.09, 804.28, 2781.15);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (244, 98, 101, 3, 800.23, 738.80, 2370.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (245, 3, 91, 7, 500.09, 995.56, 4248.46);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (246, 133, 274, 6, 785.54, 300.73, 2815.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (247, 146, 25, 7, 99.87, 164.18, 1085.18);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (248, 66, 244, 2, 450.40, 335.32, 1811.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (249, 144, 286, 5, 344.79, 412.35, 1761.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (250, 174, 102, 10, 576.31, 649.48, 880.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (251, 200, 146, 6, 325.76, 510.93, 3875.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (252, 115, 41, 7, 614.04, 464.28, 4783.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (253, 43, 173, 7, 631.64, 572.06, 4246.01);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (254, 19, 41, 3, 344.28, 314.17, 3268.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (255, 182, 137, 10, 644.99, 271.97, 2230.04);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (256, 93, 267, 8, 414.57, 184.70, 125.27);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (257, 187, 121, 5, 940.49, 700.99, 409.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (258, 43, 204, 2, 96.46, 936.85, 2371.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (259, 14, 14, 7, 524.45, 996.01, 528.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (260, 159, 80, 2, 655.17, 885.58, 1553.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (261, 64, 146, 8, 626.85, 132.14, 4194.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (262, 8, 18, 6, 860.50, 325.87, 2386.01);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (263, 139, 140, 9, 445.40, 969.56, 3491.14);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (264, 46, 234, 10, 435.54, 640.14, 2673.58);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (265, 89, 247, 9, 227.90, 90.46, 1546.26);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (266, 106, 134, 3, 304.27, 1.09, 4078.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (267, 35, 177, 5, 469.72, 9.31, 4611.22);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (268, 194, 245, 5, 10.12, 431.00, 1471.68);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (269, 60, 4, 9, 374.27, 412.32, 2807.17);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (270, 102, 128, 3, 715.22, 646.34, 4143.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (271, 57, 135, 2, 422.81, 240.32, 3825.05);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (272, 157, 140, 5, 648.80, 532.41, 1351.42);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (273, 49, 36, 3, 137.49, 111.24, 2282.16);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (274, 116, 140, 10, 492.50, 321.32, 769.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (275, 137, 12, 3, 972.35, 282.83, 633.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (276, 113, 5, 4, 91.11, 15.71, 1093.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (277, 108, 160, 8, 997.96, 464.22, 3959.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (278, 85, 42, 3, 56.98, 775.87, 366.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (279, 121, 93, 4, 895.79, 250.83, 1914.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (280, 4, 63, 4, 385.41, 974.99, 1243.34);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (281, 9, 102, 8, 735.58, 94.87, 3333.38);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (282, 54, 243, 7, 681.75, 312.79, 1622.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (283, 162, 22, 9, 521.40, 254.06, 3196.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (284, 51, 185, 1, 863.79, 218.57, 573.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (285, 163, 223, 6, 16.05, 794.59, 2927.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (286, 102, 125, 1, 968.86, 581.49, 3456.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (287, 177, 80, 6, 771.02, 249.47, 2504.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (288, 176, 174, 1, 60.71, 644.92, 3509.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (289, 28, 65, 8, 233.44, 981.68, 3944.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (290, 194, 178, 8, 733.45, 22.33, 1895.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (291, 186, 69, 5, 898.76, 485.81, 2193.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (292, 76, 278, 8, 190.58, 187.44, 1744.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (293, 188, 240, 5, 867.79, 599.08, 4304.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (294, 42, 36, 9, 155.87, 296.37, 1324.11);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (295, 94, 233, 1, 776.13, 506.45, 3670.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (296, 5, 187, 10, 239.55, 721.28, 3294.86);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (297, 138, 199, 4, 524.54, 498.05, 2761.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (298, 157, 145, 6, 410.39, 322.70, 490.32);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (299, 169, 35, 1, 835.35, 130.64, 4368.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (300, 52, 55, 8, 192.42, 32.79, 3212.34);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (301, 100, 251, 9, 624.34, 590.70, 254.94);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (302, 57, 37, 1, 930.27, 209.53, 2462.11);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (303, 21, 240, 1, 361.56, 743.73, 4453.25);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (304, 95, 30, 10, 266.55, 41.61, 361.24);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (305, 78, 40, 4, 960.62, 98.02, 3628.61);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (306, 137, 198, 4, 193.92, 657.21, 2854.44);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (307, 46, 286, 9, 415.77, 106.41, 3196.74);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (308, 92, 235, 7, 882.93, 167.64, 910.18);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (309, 103, 259, 6, 657.87, 534.36, 3003.58);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (310, 91, 162, 9, 991.46, 325.33, 1864.88);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (311, 196, 221, 6, 608.80, 563.58, 1077.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (312, 197, 282, 5, 360.64, 452.95, 4799.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (313, 1, 18, 5, 596.16, 518.09, 4967.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (314, 78, 4, 5, 984.40, 215.61, 1581.37);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (315, 198, 142, 9, 511.76, 571.09, 2862.34);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (316, 25, 20, 8, 356.30, 139.27, 1841.74);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (317, 150, 128, 4, 256.99, 301.00, 2856.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (318, 146, 112, 2, 723.85, 793.10, 872.78);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (319, 177, 296, 2, 595.63, 301.09, 3656.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (320, 148, 196, 2, 780.33, 921.94, 1678.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (321, 112, 214, 2, 869.91, 227.49, 3267.37);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (322, 155, 6, 7, 55.07, 524.85, 1603.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (323, 145, 77, 6, 502.89, 221.57, 262.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (324, 188, 202, 8, 753.08, 575.67, 459.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (325, 111, 149, 7, 148.86, 336.83, 2384.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (326, 191, 26, 9, 399.79, 85.99, 2514.10);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (327, 199, 67, 3, 481.44, 198.91, 1982.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (328, 147, 101, 9, 616.37, 735.92, 1238.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (329, 19, 137, 7, 324.08, 924.20, 457.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (330, 172, 212, 7, 365.90, 191.30, 1729.18);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (331, 168, 13, 5, 170.08, 350.36, 4109.70);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (332, 114, 75, 8, 45.83, 818.35, 1006.43);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (333, 96, 80, 2, 113.26, 55.48, 4745.22);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (334, 38, 148, 1, 343.92, 804.47, 1532.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (335, 121, 12, 6, 209.80, 538.46, 1026.97);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (336, 134, 133, 9, 483.54, 730.19, 715.32);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (337, 179, 10, 7, 583.42, 663.86, 226.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (338, 44, 31, 5, 201.49, 696.82, 1363.69);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (339, 120, 5, 2, 389.25, 272.04, 4261.89);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (340, 169, 185, 2, 20.06, 867.53, 3250.56);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (341, 60, 195, 9, 976.63, 100.50, 1584.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (342, 153, 273, 2, 187.23, 501.15, 2295.35);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (343, 183, 12, 1, 248.14, 529.88, 1674.51);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (344, 101, 81, 1, 347.43, 352.56, 3129.90);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (345, 61, 257, 5, 812.07, 626.16, 4394.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (346, 8, 285, 5, 226.35, 342.44, 1970.30);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (347, 36, 45, 7, 521.19, 678.31, 4364.78);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (348, 176, 117, 7, 241.12, 153.59, 4852.98);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (349, 155, 169, 8, 542.69, 207.55, 701.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (350, 139, 104, 3, 309.69, 705.42, 2623.79);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (351, 35, 221, 3, 656.57, 565.27, 798.66);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (352, 18, 286, 9, 948.64, 119.27, 1594.81);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (353, 38, 16, 6, 880.24, 414.62, 2062.15);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (354, 114, 141, 3, 779.32, 107.66, 931.89);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (355, 196, 137, 10, 567.47, 231.68, 1168.59);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (356, 176, 14, 6, 80.40, 780.04, 679.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (357, 155, 241, 6, 184.79, 388.07, 2374.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (358, 42, 99, 4, 33.20, 764.77, 84.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (359, 70, 212, 4, 742.62, 988.25, 3791.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (360, 17, 91, 8, 867.25, 490.45, 1631.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (361, 118, 127, 7, 405.46, 42.78, 3679.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (362, 98, 161, 7, 611.89, 742.72, 2973.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (363, 135, 20, 9, 110.21, 457.44, 4390.06);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (364, 63, 266, 9, 396.21, 735.43, 2792.93);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (365, 133, 26, 4, 291.89, 398.64, 1529.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (366, 74, 237, 3, 423.04, 613.52, 282.19);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (367, 133, 73, 8, 830.06, 452.24, 3616.01);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (368, 29, 93, 10, 937.90, 696.41, 685.18);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (369, 106, 166, 8, 25.89, 454.22, 4484.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (370, 52, 233, 2, 250.83, 692.02, 4536.74);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (371, 42, 64, 2, 115.05, 449.94, 1821.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (372, 135, 197, 9, 612.45, 160.74, 2756.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (373, 12, 88, 6, 565.92, 659.86, 758.95);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (374, 38, 92, 1, 420.16, 310.21, 3845.47);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (375, 115, 148, 3, 118.44, 132.44, 1022.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (376, 160, 130, 1, 459.18, 855.55, 2722.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (377, 2, 253, 4, 217.65, 659.80, 2274.16);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (378, 114, 41, 10, 600.50, 245.47, 2741.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (379, 159, 286, 4, 49.87, 149.11, 3269.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (380, 10, 75, 1, 667.32, 838.17, 1499.22);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (381, 23, 26, 2, 417.54, 179.07, 3363.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (382, 157, 294, 9, 178.24, 455.88, 2899.04);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (383, 10, 48, 5, 323.50, 897.62, 4103.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (384, 195, 219, 9, 65.86, 471.34, 618.90);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (385, 71, 169, 9, 414.34, 210.63, 1053.16);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (386, 15, 56, 10, 729.99, 629.34, 4936.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (387, 124, 148, 7, 609.23, 317.17, 2631.70);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (388, 160, 182, 3, 614.67, 496.90, 3648.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (389, 128, 253, 3, 883.77, 233.49, 1459.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (390, 50, 1, 2, 24.96, 625.83, 598.45);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (391, 54, 213, 7, 46.45, 350.30, 4032.16);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (392, 55, 6, 4, 690.32, 255.16, 348.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (393, 77, 260, 9, 324.60, 7.13, 3432.32);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (394, 88, 203, 10, 616.37, 30.09, 886.39);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (395, 85, 174, 8, 916.24, 797.45, 3231.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (396, 124, 80, 8, 892.16, 537.43, 1682.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (397, 106, 29, 9, 300.04, 725.23, 1584.36);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (398, 138, 10, 4, 577.81, 332.38, 4581.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (399, 91, 34, 3, 281.18, 32.14, 4918.26);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (400, 161, 274, 3, 571.40, 390.17, 2980.01);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (401, 193, 158, 6, 710.12, 272.22, 443.12);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (402, 61, 191, 8, 829.62, 303.32, 2630.25);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (403, 45, 58, 6, 785.15, 778.00, 4567.64);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (404, 114, 260, 1, 799.22, 905.04, 778.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (405, 88, 248, 9, 311.05, 328.01, 3849.71);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (406, 26, 265, 3, 205.98, 37.52, 1944.07);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (407, 134, 60, 1, 311.67, 44.99, 4242.14);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (408, 23, 171, 8, 889.29, 104.00, 3833.24);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (409, 191, 160, 1, 577.98, 312.83, 4461.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (410, 83, 103, 4, 287.28, 532.74, 3866.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (411, 172, 61, 5, 150.17, 274.36, 86.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (412, 160, 287, 9, 103.27, 542.98, 2751.33);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (413, 70, 73, 5, 574.50, 172.10, 1563.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (414, 87, 277, 8, 51.67, 29.96, 4517.43);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (415, 13, 55, 7, 54.75, 427.04, 903.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (416, 153, 229, 10, 356.27, 333.00, 998.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (417, 195, 274, 2, 973.70, 755.98, 2333.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (418, 34, 48, 8, 98.16, 311.08, 3225.65);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (419, 197, 239, 8, 232.46, 224.57, 4306.87);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (420, 158, 133, 6, 392.68, 699.91, 3329.25);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (421, 84, 233, 8, 31.23, 475.85, 1763.69);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (422, 119, 88, 5, 768.17, 604.83, 645.70);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (423, 27, 208, 2, 326.54, 649.80, 3964.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (424, 137, 237, 7, 590.94, 239.33, 1226.02);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (425, 41, 247, 7, 66.99, 209.03, 3473.36);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (426, 111, 223, 10, 787.53, 544.98, 1188.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (427, 170, 40, 10, 836.90, 115.21, 2984.42);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (428, 84, 285, 2, 822.19, 177.00, 4779.86);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (429, 18, 56, 10, 771.56, 379.53, 2476.53);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (430, 170, 32, 2, 218.39, 139.78, 2908.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (431, 194, 1, 3, 661.21, 453.52, 1464.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (432, 158, 296, 8, 196.47, 681.83, 1589.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (433, 146, 156, 7, 718.07, 915.19, 4951.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (434, 150, 5, 10, 986.43, 404.79, 646.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (435, 76, 32, 6, 901.17, 967.92, 14.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (436, 144, 184, 2, 861.38, 865.81, 1183.85);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (437, 180, 202, 6, 712.05, 406.62, 2181.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (438, 55, 89, 8, 139.93, 555.86, 4218.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (439, 93, 214, 3, 289.18, 872.85, 636.49);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (440, 3, 37, 1, 144.85, 884.99, 3293.05);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (441, 35, 44, 3, 642.59, 416.44, 2285.58);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (442, 179, 218, 10, 180.62, 509.90, 2764.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (443, 116, 197, 6, 226.51, 425.34, 47.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (444, 128, 122, 9, 269.98, 926.63, 2886.00);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (445, 9, 20, 10, 483.78, 369.21, 2905.54);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (446, 177, 41, 3, 730.45, 526.88, 4298.16);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (447, 193, 144, 8, 517.43, 523.83, 3054.25);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (448, 63, 242, 2, 684.38, 539.65, 2902.35);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (449, 157, 28, 6, 535.49, 11.77, 2275.63);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (450, 121, 294, 6, 421.59, 960.61, 3993.13);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (451, 75, 86, 1, 695.35, 598.03, 1527.31);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (452, 145, 134, 1, 629.66, 578.56, 2868.57);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (453, 169, 150, 10, 28.27, 485.27, 642.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (454, 20, 143, 5, 133.40, 281.69, 4290.71);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (455, 4, 58, 10, 175.44, 592.17, 764.17);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (456, 115, 190, 3, 261.99, 701.07, 2429.74);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (457, 136, 17, 6, 984.08, 967.37, 2981.77);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (458, 40, 254, 7, 770.59, 238.71, 2206.52);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (459, 164, 86, 4, 578.17, 841.98, 281.09);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (460, 68, 60, 1, 168.43, 399.34, 1513.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (461, 192, 273, 4, 380.42, 705.90, 2378.20);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (462, 38, 272, 7, 12.85, 927.29, 2249.61);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (463, 174, 162, 9, 683.19, 41.98, 4589.38);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (464, 164, 182, 7, 610.87, 652.41, 1370.23);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (465, 70, 137, 2, 256.09, 584.59, 2310.93);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (466, 173, 124, 10, 770.72, 520.43, 3391.81);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (467, 47, 161, 9, 11.57, 9.47, 349.08);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (468, 106, 51, 9, 104.80, 446.49, 1104.89);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (469, 73, 129, 4, 35.01, 619.77, 293.84);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (470, 153, 112, 10, 638.44, 708.36, 608.69);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (471, 155, 67, 7, 656.73, 899.99, 2834.68);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (472, 48, 57, 3, 254.08, 467.48, 4681.55);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (473, 164, 233, 5, 769.58, 692.52, 3341.22);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (474, 198, 166, 5, 162.80, 74.92, 3887.76);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (475, 98, 199, 6, 995.95, 258.98, 4065.88);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (476, 46, 226, 2, 492.23, 928.65, 3055.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (477, 46, 252, 2, 144.73, 768.93, 1099.75);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (478, 165, 55, 8, 715.68, 104.18, 373.87);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (479, 147, 129, 8, 19.75, 498.20, 3267.80);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (480, 1, 20, 7, 267.17, 700.35, 4524.04);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (481, 148, 2, 9, 707.89, 771.21, 2395.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (482, 104, 36, 9, 226.62, 385.04, 3449.41);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (483, 200, 247, 2, 567.67, 935.10, 1801.00);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (484, 175, 156, 7, 56.14, 997.01, 3238.90);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (485, 94, 274, 6, 81.38, 460.18, 3834.88);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (486, 166, 104, 3, 554.92, 967.54, 3307.06);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (487, 77, 200, 2, 630.98, 359.90, 433.46);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (488, 162, 225, 4, 140.80, 193.90, 3601.50);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (489, 152, 123, 8, 389.37, 792.94, 3220.60);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (490, 128, 274, 8, 966.60, 17.40, 1703.03);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (491, 87, 22, 7, 119.07, 807.29, 3339.91);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (492, 118, 275, 3, 741.30, 233.75, 369.45);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (493, 189, 73, 8, 654.17, 471.74, 4590.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (494, 12, 125, 3, 15.35, 633.02, 4524.27);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (495, 25, 234, 10, 171.52, 591.45, 4090.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (496, 28, 59, 8, 595.38, 616.01, 324.92);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (497, 52, 219, 6, 811.70, 982.20, 3395.21);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (498, 84, 62, 10, 546.33, 322.27, 4823.82);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (499, 55, 24, 10, 174.27, 64.16, 1376.73);
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES (500, 194, 213, 3, 696.59, 553.85, 2198.92);


-- Table: orders
-- ================================================

DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
    id INTEGER NOT NULL DEFAULT nextval('orders_id_seq'::regclass),
    order_number CHARACTER VARYING,
    user_id INTEGER,
    order_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC,
    tax_amount NUMERIC,
    shipping_cost NUMERIC,
    status CHARACTER VARYING DEFAULT 'pending'::character varying,
    shipping_address JSONB,
    payment_method CHARACTER VARYING
);

-- Data for table orders (200 records)
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (1, 'ORD-8877722802', 144, 2025-05-04 06:20:53, 4421.83, 2037.82, 621.03, 'processing', '{"city": "West Michael", "state": "Louisiana", "street": "53817 Karen Trace", "country": "Pitcairn Islands", "zip_code": "66504"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (2, 'ORD-6111434048', 42, 2024-08-22 22:27:03, 4881.27, 4055.75, 881.53, 'pending', '{"city": "Shannonstad", "state": "Utah", "street": "5778 Theodore Place", "country": "Sudan", "zip_code": "91363"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (3, 'ORD-3793015896', 86, 2024-10-13 22:25:46, 3914.11, 2064.45, 670.23, 'processing', '{"city": "West Robertside", "state": "Florida", "street": "16241 Fred Creek Apt. 723", "country": "Guatemala", "zip_code": "62616"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (4, 'ORD-6099411776', 41, 2025-05-15 06:47:43, 3939.00, 549.40, 872.29, 'delivered', '{"city": "Toddhaven", "state": "Oklahoma", "street": "3103 Jenkins Junctions", "country": "Kuwait", "zip_code": "58861"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (5, 'ORD-9895958293', 52, 2024-09-22 00:44:58, 4084.77, 2306.91, 305.88, 'processing', '{"city": "Ianburgh", "state": "Virginia", "street": "43754 Eddie Haven Suite 292", "country": "United Kingdom", "zip_code": "91315"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (6, 'ORD-659212199', 7, 2024-11-02 04:17:07, 3303.57, 1998.35, 279.32, 'pending', '{"city": "Lake Loganstad", "state": "Georgia", "street": "59274 Lopez Points", "country": "Kiribati", "zip_code": "49379"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (7, 'ORD-9288286000', 90, 2024-11-26 21:35:15, 3210.99, 2004.40, 981.16, 'cancelled', '{"city": "Deborahport", "state": "New Mexico", "street": "67275 Adam Streets", "country": "Western Sahara", "zip_code": "38489"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (8, 'ORD-2864261005', 8, 2025-06-08 07:26:13, 585.56, 4852.30, 179.39, 'shipped', '{"city": "Brianborough", "state": "Pennsylvania", "street": "1702 Kyle Locks Apt. 751", "country": "Cyprus", "zip_code": "69501"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (9, 'ORD-7589615766', 28, 2024-10-16 19:02:57, 2986.89, 1734.98, 786.63, 'delivered', '{"city": "Lake Michaelberg", "state": "Virginia", "street": "87186 Tracy Rapids", "country": "Heard Island and McDonald Islands", "zip_code": "56552"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (10, 'ORD-5953308368', 99, 2024-08-06 12:28:24, 4498.53, 958.49, 45.34, 'delivered', '{"city": "Chandlerchester", "state": "Florida", "street": "5478 Jason Mills Suite 742", "country": "Netherlands Antilles", "zip_code": "77463"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (11, 'ORD-369702097', 134, 2024-10-21 11:31:56, 4628.62, 2696.88, 719.70, 'processing', '{"city": "Pageberg", "state": "Illinois", "street": "8519 Davis Lodge Suite 628", "country": "Syrian Arab Republic", "zip_code": "24881"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (12, 'ORD-5934654971', 111, 2025-03-04 21:15:39, 359.17, 3324.55, 330.87, 'shipped', '{"city": "Martinezport", "state": "Nebraska", "street": "49478 Walker Turnpike Apt. 244", "country": "Liechtenstein", "zip_code": "24011"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (13, 'ORD-2769334117', 77, 2024-08-12 19:57:03, 2540.54, 3337.80, 326.85, 'shipped', '{"city": "Courtneyfort", "state": "Vermont", "street": "7195 Cunningham Ways", "country": "Holy See (Vatican City State)", "zip_code": "16175"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (14, 'ORD-2470738735', 50, 2025-06-26 01:25:41, 2108.03, 4702.41, 677.63, 'processing', '{"city": "West Kellyland", "state": "North Carolina", "street": "90257 Michael Center Suite 565", "country": "Seychelles", "zip_code": "25904"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (15, 'ORD-2697368099', 104, 2025-05-25 18:16:06, 2744.21, 12.03, 287.62, 'delivered', '{"city": "Josephstad", "state": "Connecticut", "street": "285 Serrano Spur", "country": "Mozambique", "zip_code": "70548"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (16, 'ORD-617262027', 120, 2024-09-23 23:18:29, 2214.51, 3381.38, 511.66, 'processing', '{"city": "South Stevenland", "state": "Delaware", "street": "7652 Jeffery Parkway Apt. 389", "country": "Uzbekistan", "zip_code": "17701"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (17, 'ORD-4369611254', 73, 2024-12-15 00:23:54, 2582.11, 3168.37, 335.85, 'processing', '{"city": "Lake Jeremy", "state": "Florida", "street": "527 Jackson Hollow Apt. 132", "country": "Bulgaria", "zip_code": "28005"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (18, 'ORD-4213833526', 58, 2025-01-13 18:19:01, 4034.75, 745.30, 47.17, 'delivered', '{"city": "South Davidview", "state": "Arizona", "street": "07603 Antonio Shoals", "country": "Gabon", "zip_code": "09184"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (19, 'ORD-2867261857', 117, 2025-05-21 19:45:54, 2078.06, 3152.53, 195.24, 'delivered', '{"city": "Stacystad", "state": "Minnesota", "street": "93932 Johnson Drive", "country": "Timor-Leste", "zip_code": "21545"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (20, 'ORD-9628554412', 103, 2025-03-11 05:49:32, 1227.48, 3283.73, 6.54, 'pending', '{"city": "Lake Coreyborough", "state": "North Carolina", "street": "90833 Jackson Throughway", "country": "Lebanon", "zip_code": "93268"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (21, 'ORD-2531370274', 57, 2025-01-19 12:49:46, 887.67, 4790.25, 518.43, 'pending', '{"city": "Davidville", "state": "North Dakota", "street": "56638 Rick Trace", "country": "Lithuania", "zip_code": "18315"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (22, 'ORD-7568907829', 32, 2025-05-02 11:24:54, 2287.74, 4009.07, 667.90, 'cancelled', '{"city": "New Richard", "state": "Nevada", "street": "015 Wilson Haven Suite 947", "country": "Togo", "zip_code": "25245"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (23, 'ORD-7211813187', 114, 2024-10-10 10:01:07, 3067.14, 3599.18, 505.27, 'cancelled', '{"city": "North Douglasfurt", "state": "Vermont", "street": "716 Mills Springs", "country": "Bosnia and Herzegovina", "zip_code": "77906"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (24, 'ORD-724660700', 41, 2024-12-21 00:52:11, 3720.84, 2378.63, 259.93, 'processing', '{"city": "Ramirezshire", "state": "Pennsylvania", "street": "3961 Mary Stream", "country": "Saudi Arabia", "zip_code": "36280"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (25, 'ORD-6013965794', 134, 2025-02-02 13:52:09, 2428.14, 1203.84, 440.43, 'shipped', '{"city": "Lake Brianland", "state": "New York", "street": "8427 David Overpass Suite 320", "country": "Anguilla", "zip_code": "89381"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (26, 'ORD-4175019827', 70, 2024-12-28 09:14:41, 1685.88, 4466.20, 81.50, 'processing', '{"city": "Amyside", "state": "Ohio", "street": "49911 Sparks Flats Suite 778", "country": "Zambia", "zip_code": "02817"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (27, 'ORD-3281204295', 99, 2025-01-15 22:31:31, 3472.81, 3535.03, 65.16, 'delivered', '{"city": "Nicoleburgh", "state": "New York", "street": "7567 Johnson Fall", "country": "Burkina Faso", "zip_code": "56951"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (28, 'ORD-9931938682', 139, 2024-12-30 21:20:23, 2334.96, 320.71, 833.05, 'delivered', '{"city": "Troyfurt", "state": "South Carolina", "street": "97889 Alvarez Walk Apt. 806", "country": "Guinea", "zip_code": "89169"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (29, 'ORD-5516617218', 148, 2024-08-25 15:21:35, 1908.10, 39.42, 352.40, 'delivered', '{"city": "Port Patriciamouth", "state": "Missouri", "street": "025 Pacheco Prairie", "country": "Japan", "zip_code": "13260"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (30, 'ORD-5829842920', 138, 2024-12-16 04:54:49, 3740.10, 2735.20, 603.64, 'processing', '{"city": "Port Kevinmouth", "state": "Hawaii", "street": "333 Watkins Spurs", "country": "Mauritania", "zip_code": "03084"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (31, 'ORD-1400661168', 57, 2025-01-27 18:50:01, 1371.95, 2433.35, 389.46, 'delivered', '{"city": "Morrisville", "state": "New York", "street": "864 Heather Radial Apt. 569", "country": "Portugal", "zip_code": "13615"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (32, 'ORD-2899580938', 120, 2024-12-10 06:17:26, 4598.51, 4903.80, 534.58, 'delivered', '{"city": "West Joseph", "state": "Maryland", "street": "529 Cox Mews Apt. 718", "country": "Iran", "zip_code": "75673"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (33, 'ORD-3455743663', 22, 2025-04-01 08:16:57, 3217.32, 687.14, 462.23, 'pending', '{"city": "Simmonsstad", "state": "California", "street": "919 Nelson Port", "country": "Swaziland", "zip_code": "85899"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (34, 'ORD-9886357637', 98, 2025-06-10 01:51:04, 1643.49, 2278.95, 338.16, 'delivered', '{"city": "New Victor", "state": "Texas", "street": "8536 King Passage Suite 820", "country": "Wallis and Futuna", "zip_code": "97783"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (35, 'ORD-6301985407', 108, 2025-07-31 17:50:18, 1268.83, 418.71, 20.36, 'cancelled', '{"city": "Michelleland", "state": "South Dakota", "street": "083 Ford Garden Apt. 466", "country": "Tanzania", "zip_code": "27181"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (36, 'ORD-6066376657', 90, 2025-06-17 16:23:13, 1128.87, 352.41, 957.32, 'pending', '{"city": "Stevenside", "state": "Nevada", "street": "249 Richard Crescent Apt. 303", "country": "Oman", "zip_code": "55815"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (37, 'ORD-3889761307', 64, 2024-10-19 05:32:05, 1004.81, 111.70, 153.23, 'processing', '{"city": "Caseyton", "state": "Colorado", "street": "2044 Dawn Canyon", "country": "Netherlands", "zip_code": "41645"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (38, 'ORD-8397041061', 30, 2025-07-16 01:22:45, 2824.21, 1097.64, 699.76, 'shipped', '{"city": "Tylerland", "state": "Kansas", "street": "162 Daniel Street Apt. 898", "country": "British Virgin Islands", "zip_code": "79120"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (39, 'ORD-5641054403', 30, 2025-06-21 00:45:49, 3891.18, 827.19, 311.72, 'cancelled', '{"city": "South Amandaville", "state": "Massachusetts", "street": "363 Daniel Forest Suite 764", "country": "Jamaica", "zip_code": "72032"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (40, 'ORD-4917357577', 80, 2025-02-02 08:14:05, 2883.23, 4541.05, 375.93, 'processing', '{"city": "Port Scott", "state": "Alabama", "street": "0900 Johnny Lights Suite 518", "country": "Vanuatu", "zip_code": "52009"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (41, 'ORD-5392476150', 63, 2024-09-05 20:02:27, 518.49, 3864.68, 850.43, 'cancelled', '{"city": "Port Kimberlyfort", "state": "New Mexico", "street": "3275 Mccormick Harbor", "country": "Isle of Man", "zip_code": "97093"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (42, 'ORD-9278604024', 145, 2024-11-11 03:15:51, 3915.35, 1742.55, 428.95, 'shipped', '{"city": "Lake Darlenemouth", "state": "Tennessee", "street": "6985 Neal Track", "country": "Afghanistan", "zip_code": "18338"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (43, 'ORD-1720829540', 130, 2025-04-02 18:59:33, 3241.24, 73.13, 420.63, 'delivered', '{"city": "Mendozaberg", "state": "Kentucky", "street": "9112 Zachary Trafficway Apt. 965", "country": "Poland", "zip_code": "23239"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (44, 'ORD-1210310334', 111, 2024-09-03 13:30:07, 4804.33, 3181.57, 828.87, 'processing', '{"city": "Jacquelineburgh", "state": "Arkansas", "street": "2669 Andrew Brooks Apt. 173", "country": "Niger", "zip_code": "53065"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (45, 'ORD-1117369169', 46, 2024-09-05 08:57:29, 3671.64, 4827.71, 270.81, 'cancelled', '{"city": "Keithfort", "state": "Missouri", "street": "91086 Wilcox Park Apt. 333", "country": "Jersey", "zip_code": "17566"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (46, 'ORD-3677942534', 120, 2025-03-22 20:01:26, 2183.52, 3657.82, 269.12, 'processing', '{"city": "New Shannon", "state": "Kansas", "street": "3626 Anthony Greens", "country": "Myanmar", "zip_code": "48950"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (47, 'ORD-1967799880', 72, 2024-08-05 19:02:18, 4409.34, 1226.88, 465.24, 'cancelled', '{"city": "Odonnellton", "state": "Alabama", "street": "56366 Jones Point Apt. 053", "country": "Madagascar", "zip_code": "33748"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (48, 'ORD-6956377623', 87, 2024-11-27 06:25:11, 153.21, 4256.25, 182.66, 'processing', '{"city": "Andersonmouth", "state": "Virginia", "street": "528 Beverly Green Apt. 875", "country": "Jersey", "zip_code": "70024"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (49, 'ORD-4903975336', 67, 2024-09-16 03:53:37, 1708.29, 4402.80, 701.48, 'shipped', '{"city": "West Jillian", "state": "New York", "street": "27456 Orr Greens Suite 856", "country": "Moldova", "zip_code": "20327"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (50, 'ORD-7723296882', 133, 2024-08-22 10:54:49, 4740.83, 437.21, 720.35, 'delivered', '{"city": "Wilsonfort", "state": "Arizona", "street": "03207 Martin Mountain", "country": "Guinea-Bissau", "zip_code": "58371"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (51, 'ORD-6703819127', 122, 2025-01-26 13:28:35, 3233.06, 2459.20, 793.13, 'pending', '{"city": "New Katieburgh", "state": "Nebraska", "street": "21513 White Extension Suite 993", "country": "Egypt", "zip_code": "10571"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (52, 'ORD-7594590645', 57, 2025-04-21 16:05:29, 2027.96, 1224.09, 664.29, 'shipped', '{"city": "Ericland", "state": "New Jersey", "street": "0416 Garza Coves", "country": "Palestinian Territory", "zip_code": "93261"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (53, 'ORD-6355929233', 142, 2025-04-02 19:33:22, 2659.30, 2133.26, 746.18, 'shipped', '{"city": "Laurenland", "state": "Oklahoma", "street": "050 Nguyen Street Apt. 304", "country": "Hong Kong", "zip_code": "79444"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (54, 'ORD-4692470851', 117, 2024-11-08 21:08:48, 1361.87, 1264.50, 121.53, 'processing', '{"city": "North Kenneth", "state": "Nevada", "street": "61032 Chan Haven", "country": "Sri Lanka", "zip_code": "96955"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (55, 'ORD-8253637840', 31, 2025-07-18 18:15:39, 3716.98, 4754.88, 690.47, 'processing', '{"city": "Adamschester", "state": "Colorado", "street": "1583 Griffin Loaf", "country": "Jamaica", "zip_code": "99655"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (56, 'ORD-7778161564', 124, 2025-03-28 04:30:33, 1389.73, 2952.04, 760.44, 'cancelled', '{"city": "Lake Gina", "state": "Georgia", "street": "6108 Mcpherson Springs", "country": "Malta", "zip_code": "65423"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (57, 'ORD-2253473926', 26, 2024-11-22 16:23:43, 4164.82, 1488.27, 361.52, 'shipped', '{"city": "New Charleston", "state": "North Carolina", "street": "1742 Gabrielle Hills Apt. 864", "country": "Malawi", "zip_code": "14608"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (58, 'ORD-6119956976', 137, 2024-09-07 11:30:18, 641.65, 237.12, 55.47, 'shipped', '{"city": "Port Phillip", "state": "Colorado", "street": "945 Richards Trafficway Apt. 172", "country": "Turkey", "zip_code": "55059"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (59, 'ORD-7320250168', 126, 2024-12-01 17:02:20, 521.91, 71.20, 285.05, 'delivered', '{"city": "Monicaville", "state": "Nevada", "street": "794 Levy Well Apt. 321", "country": "Andorra", "zip_code": "70542"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (60, 'ORD-4320080287', 88, 2024-09-16 02:22:01, 929.97, 266.37, 941.11, 'delivered', '{"city": "Hannahfurt", "state": "Maryland", "street": "77697 Montgomery Ridges", "country": "Brunei Darussalam", "zip_code": "11987"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (61, 'ORD-580310006', 17, 2024-10-14 21:15:04, 2009.53, 379.67, 629.81, 'pending', '{"city": "North Kevin", "state": "New Jersey", "street": "30372 Ryan Road", "country": "Lebanon", "zip_code": "19921"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (62, 'ORD-1811957488', 39, 2024-09-16 00:19:18, 4057.60, 4746.14, 86.09, 'processing', '{"city": "Williamstown", "state": "Connecticut", "street": "77707 James Port", "country": "Tanzania", "zip_code": "83130"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (63, 'ORD-7357677623', 143, 2025-01-10 05:19:13, 3824.57, 3035.53, 790.94, 'processing', '{"city": "Hallton", "state": "North Dakota", "street": "998 Johnson Locks Suite 899", "country": "Jamaica", "zip_code": "02993"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (64, 'ORD-6770600848', 116, 2025-03-04 15:33:49, 4543.44, 1493.79, 588.93, 'delivered', '{"city": "East Keithborough", "state": "New Mexico", "street": "6717 West Mews", "country": "Kazakhstan", "zip_code": "45569"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (65, 'ORD-9586809869', 146, 2024-10-26 02:37:16, 3108.93, 3052.06, 740.34, 'processing', '{"city": "West Hannah", "state": "Colorado", "street": "724 Moyer Village Suite 729", "country": "Liberia", "zip_code": "87933"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (66, 'ORD-554465497', 68, 2024-10-18 06:10:28, 3305.54, 793.71, 174.64, 'pending', '{"city": "North Michaelview", "state": "Minnesota", "street": "716 Torres Fords", "country": "Cayman Islands", "zip_code": "89227"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (67, 'ORD-2162425423', 1, 2025-06-11 02:54:46, 2048.50, 3449.96, 470.44, 'pending', '{"city": "Victoriastad", "state": "Wyoming", "street": "6193 Anna Oval", "country": "Sierra Leone", "zip_code": "06618"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (68, 'ORD-2875420006', 74, 2025-05-03 03:01:04, 3537.71, 3517.91, 454.57, 'processing', '{"city": "East Crystalborough", "state": "Mississippi", "street": "7119 Madison Canyon", "country": "Saint Lucia", "zip_code": "21083"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (69, 'ORD-9844593278', 51, 2025-01-20 06:05:31, 2131.44, 2727.37, 647.98, 'shipped', '{"city": "Port Lisa", "state": "Michigan", "street": "125 Fuentes Crossing Apt. 760", "country": "Madagascar", "zip_code": "38086"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (70, 'ORD-735563832', 19, 2024-11-13 02:17:32, 307.59, 3965.22, 595.44, 'cancelled', '{"city": "Hardinmouth", "state": "North Dakota", "street": "653 Karen Pines Suite 326", "country": "Guyana", "zip_code": "89918"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (71, 'ORD-4053333550', 113, 2025-01-20 15:58:45, 630.52, 3446.50, 700.03, 'shipped', '{"city": "Brownton", "state": "Texas", "street": "81155 Holden Expressway", "country": "Canada", "zip_code": "84579"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (72, 'ORD-5565094025', 113, 2025-01-04 21:47:05, 411.40, 208.91, 432.59, 'shipped', '{"city": "Terryfurt", "state": "Wyoming", "street": "550 Mccullough Ridge Apt. 673", "country": "Turkmenistan", "zip_code": "26360"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (73, 'ORD-1295067571', 7, 2024-08-16 03:26:02, 465.72, 4809.94, 836.11, 'cancelled', '{"city": "North Pamelaside", "state": "Pennsylvania", "street": "2884 Christopher Plaza Suite 852", "country": "Dominican Republic", "zip_code": "34408"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (74, 'ORD-9895355925', 69, 2025-01-12 23:07:26, 2885.47, 3817.91, 176.01, 'cancelled', '{"city": "South Kennethtown", "state": "New Jersey", "street": "054 Martinez Throughway", "country": "Dominica", "zip_code": "44931"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (75, 'ORD-2557863130', 72, 2024-12-15 20:13:32, 915.63, 2930.79, 635.14, 'delivered', '{"city": "Lake Ronald", "state": "Nebraska", "street": "9268 Daniel Path Apt. 571", "country": "Bermuda", "zip_code": "11241"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (76, 'ORD-4562087085', 121, 2025-07-12 20:21:13, 1746.33, 1673.21, 670.46, 'processing', '{"city": "Wigginsshire", "state": "New York", "street": "3715 Chapman Path", "country": "Jamaica", "zip_code": "83923"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (77, 'ORD-8574952781', 106, 2025-04-26 08:57:31, 3471.43, 1448.21, 945.24, 'cancelled', '{"city": "South Thomas", "state": "West Virginia", "street": "622 Todd Mount Apt. 881", "country": "Western Sahara", "zip_code": "21058"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (78, 'ORD-6695968652', 117, 2025-07-25 17:41:20, 449.42, 1269.47, 116.80, 'delivered', '{"city": "North Nathan", "state": "Mississippi", "street": "611 Armstrong Canyon", "country": "French Polynesia", "zip_code": "40249"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (79, 'ORD-2087034313', 139, 2025-06-05 01:23:59, 2315.26, 280.48, 518.92, 'cancelled', '{"city": "Smithside", "state": "Minnesota", "street": "96044 Isaac Streets", "country": "Trinidad and Tobago", "zip_code": "09356"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (80, 'ORD-4486877079', 114, 2025-02-04 15:44:10, 3802.35, 1025.76, 549.66, 'shipped', '{"city": "Contrerasberg", "state": "Washington", "street": "756 Davenport Village Apt. 287", "country": "Benin", "zip_code": "43127"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (81, 'ORD-6054307581', 125, 2024-10-31 04:54:28, 615.92, 4866.00, 609.26, 'processing', '{"city": "Lake Anitaborough", "state": "South Carolina", "street": "8074 Michelle Station Apt. 948", "country": "Morocco", "zip_code": "71520"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (82, 'ORD-3253932355', 80, 2025-03-11 05:54:35, 2758.69, 2765.73, 94.12, 'pending', '{"city": "East Maria", "state": "Pennsylvania", "street": "8018 Suzanne Harbor", "country": "Belize", "zip_code": "58727"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (83, 'ORD-6901388916', 31, 2025-01-04 19:52:28, 3242.07, 778.32, 932.71, 'shipped', '{"city": "Patrickland", "state": "Delaware", "street": "0562 Johnson Pines", "country": "Mauritius", "zip_code": "13520"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (84, 'ORD-5017191787', 107, 2024-09-26 17:20:36, 4175.27, 4901.42, 244.48, 'cancelled', '{"city": "North Jennifer", "state": "Maryland", "street": "1246 Brian Islands", "country": "Bolivia", "zip_code": "51611"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (85, 'ORD-1374567624', 99, 2025-01-09 02:38:03, 961.15, 3000.89, 746.54, 'processing', '{"city": "Averyview", "state": "Arkansas", "street": "6103 Karen Radial Apt. 788", "country": "Kyrgyz Republic", "zip_code": "42225"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (86, 'ORD-6670604282', 71, 2024-08-27 04:57:42, 3865.65, 4273.52, 340.53, 'cancelled', '{"city": "Millerhaven", "state": "Indiana", "street": "63048 John Point Apt. 496", "country": "Holy See (Vatican City State)", "zip_code": "19161"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (87, 'ORD-9642895146', 1, 2025-01-13 08:30:21, 1421.37, 1499.79, 587.34, 'delivered', '{"city": "Meganborough", "state": "Pennsylvania", "street": "07942 Brian Orchard Suite 946", "country": "Finland", "zip_code": "67390"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (88, 'ORD-195355435', 115, 2025-05-15 20:31:52, 2697.52, 1732.17, 552.36, 'cancelled', '{"city": "Nicolemouth", "state": "South Dakota", "street": "1612 Johns Fords", "country": "Sao Tome and Principe", "zip_code": "34758"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (89, 'ORD-7334747974', 117, 2024-11-15 19:30:49, 4664.93, 4349.31, 980.78, 'processing', '{"city": "Lake Dennistown", "state": "Rhode Island", "street": "553 Haley Isle", "country": "Albania", "zip_code": "62960"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (90, 'ORD-3871676777', 60, 2025-04-20 00:55:30, 4281.50, 2059.77, 318.85, 'delivered', '{"city": "New Anthonymouth", "state": "Utah", "street": "8768 Kristin Run", "country": "Guinea", "zip_code": "16677"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (91, 'ORD-6877577855', 99, 2024-12-29 23:37:40, 4942.19, 3964.04, 652.36, 'processing', '{"city": "East Juliaview", "state": "Utah", "street": "017 Mayer Mills", "country": "Guinea-Bissau", "zip_code": "93456"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (92, 'ORD-822536398', 10, 2025-06-14 19:08:08, 639.97, 4827.11, 332.66, 'pending', '{"city": "Port Joshuahaven", "state": "New York", "street": "337 Johnson Park Apt. 036", "country": "Micronesia", "zip_code": "22845"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (93, 'ORD-9422171498', 26, 2025-05-15 17:06:00, 2634.50, 2290.07, 722.71, 'delivered', '{"city": "Jamestown", "state": "Vermont", "street": "92124 Nicole Stream", "country": "Martinique", "zip_code": "89333"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (94, 'ORD-6934038104', 20, 2025-04-23 03:14:51, 2352.76, 4846.33, 339.22, 'delivered', '{"city": "Lake Jeffreyview", "state": "Nebraska", "street": "60566 Martinez Path Suite 758", "country": "Kiribati", "zip_code": "70285"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (95, 'ORD-1358248920', 85, 2024-12-31 23:14:11, 4263.18, 4298.12, 380.63, 'shipped', '{"city": "East Mark", "state": "California", "street": "1903 Rosario Gateway", "country": "Niue", "zip_code": "82551"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (96, 'ORD-415435433', 139, 2025-02-04 04:27:29, 189.14, 351.42, 631.52, 'shipped', '{"city": "Port Carolmouth", "state": "Wisconsin", "street": "95431 Allen Junctions Apt. 583", "country": "Niue", "zip_code": "13040"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (97, 'ORD-536125194', 24, 2024-08-25 08:29:24, 2175.52, 501.23, 634.11, 'pending', '{"city": "Joneston", "state": "Oklahoma", "street": "5120 Brown Ridge", "country": "French Polynesia", "zip_code": "07343"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (98, 'ORD-7945385914', 43, 2025-01-04 18:48:16, 3473.07, 4518.09, 46.94, 'pending', '{"city": "Hobbsville", "state": "Michigan", "street": "639 Shawn Mountain", "country": "Wallis and Futuna", "zip_code": "85818"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (99, 'ORD-4406516541', 92, 2025-02-18 15:37:13, 1880.46, 736.39, 531.63, 'cancelled', '{"city": "Michaelfort", "state": "Washington", "street": "311 Brooke Cliff Apt. 928", "country": "Kenya", "zip_code": "81877"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (100, 'ORD-798534963', 44, 2024-09-24 06:02:58, 883.60, 3051.36, 383.16, 'processing', '{"city": "East Terrance", "state": "Rhode Island", "street": "24968 Collins Plains", "country": "French Guiana", "zip_code": "45445"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (101, 'ORD-8624645834', 150, 2025-03-17 12:51:47, 724.16, 2311.14, 254.72, 'shipped', '{"city": "Port Casey", "state": "Illinois", "street": "38806 Gonzalez Flats", "country": "Lebanon", "zip_code": "88038"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (102, 'ORD-8512295568', 120, 2025-03-22 17:02:12, 4507.04, 3391.28, 158.82, 'delivered', '{"city": "North Danielle", "state": "Vermont", "street": "959 Barnes Estates Apt. 707", "country": "Lao People''s Democratic Republic", "zip_code": "30683"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (103, 'ORD-2679716064', 77, 2024-11-02 14:39:57, 3198.30, 2127.30, 250.85, 'shipped', '{"city": "New Dariusport", "state": "New Hampshire", "street": "563 Lopez Avenue Suite 015", "country": "Norfolk Island", "zip_code": "25981"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (104, 'ORD-7582905353', 99, 2024-08-18 20:04:10, 4268.14, 542.20, 381.98, 'shipped', '{"city": "East James", "state": "Idaho", "street": "34234 Matthew Plaza", "country": "United States Minor Outlying Islands", "zip_code": "34814"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (105, 'ORD-434608701', 76, 2025-06-20 16:28:58, 119.48, 4151.89, 396.41, 'pending', '{"city": "Donnahaven", "state": "South Carolina", "street": "1534 Allen Valleys", "country": "Turkey", "zip_code": "57349"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (106, 'ORD-3053473268', 128, 2024-09-16 19:17:05, 4165.87, 4515.65, 775.96, 'processing', '{"city": "North Kathryn", "state": "Pennsylvania", "street": "33865 Greene Roads", "country": "Timor-Leste", "zip_code": "25286"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (107, 'ORD-6594786332', 57, 2025-06-04 10:20:18, 3186.72, 3108.25, 678.08, 'processing', '{"city": "Gibbsland", "state": "Hawaii", "street": "3042 Clark Common", "country": "Iceland", "zip_code": "67166"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (108, 'ORD-6481786488', 11, 2025-02-11 10:01:18, 1551.58, 2209.71, 579.99, 'processing', '{"city": "Royfurt", "state": "Indiana", "street": "55877 Adams Locks Apt. 333", "country": "Jamaica", "zip_code": "40608"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (109, 'ORD-8111943073', 76, 2025-03-11 16:24:17, 1640.33, 2083.36, 201.59, 'cancelled', '{"city": "Jerryton", "state": "New Jersey", "street": "4812 Kenneth Path", "country": "Nigeria", "zip_code": "67644"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (110, 'ORD-5739682547', 136, 2025-01-23 23:52:51, 2513.96, 1369.91, 165.38, 'delivered', '{"city": "Rachelport", "state": "North Carolina", "street": "6575 Reyes Fall Suite 341", "country": "Mayotte", "zip_code": "67713"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (111, 'ORD-2764474604', 87, 2025-06-02 23:43:01, 4023.12, 2346.97, 76.22, 'processing', '{"city": "Lake Cassandra", "state": "Florida", "street": "11150 Matthew Spring Suite 444", "country": "Saint Barthelemy", "zip_code": "99117"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (112, 'ORD-8213620437', 143, 2024-08-05 02:23:18, 1835.22, 3955.50, 14.90, 'cancelled', '{"city": "South Jesus", "state": "Pennsylvania", "street": "5669 Thomas Passage Apt. 633", "country": "Saudi Arabia", "zip_code": "72933"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (113, 'ORD-7792778835', 117, 2024-12-12 02:01:27, 1849.24, 3747.57, 262.90, 'delivered', '{"city": "West Donberg", "state": "Maryland", "street": "3663 Cole Point", "country": "Algeria", "zip_code": "97206"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (114, 'ORD-5818230909', 28, 2024-10-28 08:34:19, 3377.43, 2362.67, 619.92, 'cancelled', '{"city": "Bairdborough", "state": "Montana", "street": "6845 Ashley Bypass Apt. 259", "country": "Martinique", "zip_code": "08851"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (115, 'ORD-1659720707', 57, 2025-02-02 04:05:43, 3241.79, 3180.67, 464.80, 'shipped', '{"city": "North Margaret", "state": "Rhode Island", "street": "9741 Damon Plaza", "country": "Anguilla", "zip_code": "64544"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (116, 'ORD-801836494', 30, 2024-08-28 18:33:01, 707.49, 4731.85, 305.06, 'delivered', '{"city": "Mooreville", "state": "Florida", "street": "3348 Shawn Land Apt. 256", "country": "Italy", "zip_code": "70814"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (117, 'ORD-4590302102', 25, 2025-07-18 16:53:34, 1181.65, 2692.36, 389.25, 'shipped', '{"city": "Hilltown", "state": "Georgia", "street": "34672 Matthews Parkway", "country": "Bahrain", "zip_code": "58923"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (118, 'ORD-7836522697', 40, 2025-03-24 16:26:40, 4428.21, 3278.06, 833.85, 'cancelled', '{"city": "West Debbiemouth", "state": "Minnesota", "street": "597 Ford Canyon", "country": "Tajikistan", "zip_code": "92292"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (119, 'ORD-5572499854', 72, 2025-03-27 20:40:38, 173.25, 1858.94, 443.94, 'processing', '{"city": "Lake Ashley", "state": "Montana", "street": "3296 Cruz Shoals", "country": "Yemen", "zip_code": "92073"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (120, 'ORD-187537466', 26, 2025-07-11 16:41:41, 4904.83, 1843.00, 901.79, 'shipped', '{"city": "West Charlesville", "state": "North Carolina", "street": "8413 Jenkins Track", "country": "Ireland", "zip_code": "43232"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (121, 'ORD-1936755326', 102, 2024-11-07 22:48:09, 1386.65, 4841.35, 949.05, 'delivered', '{"city": "Jamesfurt", "state": "Illinois", "street": "070 Danielle Spring", "country": "Argentina", "zip_code": "52493"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (122, 'ORD-4341083932', 55, 2024-09-15 07:46:02, 3212.11, 2989.76, 22.34, 'shipped', '{"city": "Taylorview", "state": "Hawaii", "street": "7771 Amy Gardens", "country": "Taiwan", "zip_code": "22860"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (123, 'ORD-8667528031', 33, 2024-09-09 19:42:56, 3937.02, 1033.98, 829.98, 'cancelled', '{"city": "Ericstad", "state": "Idaho", "street": "1862 Emily Branch", "country": "Rwanda", "zip_code": "28900"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (124, 'ORD-5223395333', 56, 2025-04-29 08:57:23, 4067.13, 1172.66, 774.59, 'cancelled', '{"city": "North Kelseyborough", "state": "Kansas", "street": "816 Wallace Rapid", "country": "United States of America", "zip_code": "49606"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (125, 'ORD-1024522901', 71, 2024-09-06 06:37:48, 4293.45, 731.99, 130.86, 'shipped', '{"city": "Lake Gary", "state": "Nebraska", "street": "0053 Jeffrey Court", "country": "Botswana", "zip_code": "67675"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (126, 'ORD-7798047141', 29, 2024-12-05 02:26:18, 3308.68, 138.64, 15.85, 'processing', '{"city": "West Marcustown", "state": "Montana", "street": "386 Martinez Forest", "country": "Germany", "zip_code": "86221"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (127, 'ORD-4346426918', 5, 2024-10-23 09:59:16, 879.49, 271.47, 741.97, 'cancelled', '{"city": "West Susan", "state": "Rhode Island", "street": "14950 Nicole Loop Suite 971", "country": "Norfolk Island", "zip_code": "43014"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (128, 'ORD-7285619035', 17, 2025-04-22 01:20:15, 2386.47, 3892.31, 513.72, 'pending', '{"city": "Reyesbury", "state": "North Carolina", "street": "2571 Smith Prairie", "country": "Romania", "zip_code": "77501"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (129, 'ORD-4245063515', 129, 2024-10-31 02:53:28, 1115.53, 3079.38, 727.51, 'cancelled', '{"city": "North Devinfort", "state": "Maine", "street": "143 Todd River", "country": "Canada", "zip_code": "26979"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (130, 'ORD-1613825121', 118, 2025-04-08 03:04:59, 3220.27, 165.44, 998.58, 'delivered', '{"city": "New Latoyachester", "state": "Tennessee", "street": "97524 Schneider Trace", "country": "Sao Tome and Principe", "zip_code": "38309"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (131, 'ORD-101762093', 28, 2025-06-26 16:51:06, 2456.44, 4549.41, 74.42, 'pending', '{"city": "Isaiahtown", "state": "California", "street": "3380 Laurie Square Apt. 968", "country": "Bangladesh", "zip_code": "64941"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (132, 'ORD-4095943641', 38, 2024-08-22 00:31:05, 337.75, 1382.33, 633.44, 'cancelled', '{"city": "Hardyport", "state": "Hawaii", "street": "21298 Joel Common", "country": "Congo", "zip_code": "95092"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (133, 'ORD-5346911997', 98, 2024-10-09 07:20:42, 4973.19, 2657.48, 454.26, 'cancelled', '{"city": "West Raymondburgh", "state": "New Mexico", "street": "4973 Huffman Orchard", "country": "Jamaica", "zip_code": "58353"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (134, 'ORD-7451459487', 26, 2025-05-24 01:35:04, 3967.55, 580.93, 655.05, 'cancelled', '{"city": "West Oscar", "state": "Maryland", "street": "0661 Larson Drives", "country": "Finland", "zip_code": "59955"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (135, 'ORD-6897826389', 111, 2024-08-29 17:22:23, 2263.26, 1150.18, 339.59, 'delivered', '{"city": "Wallerstad", "state": "Missouri", "street": "73230 Michelle Stream Suite 766", "country": "Gambia", "zip_code": "64667"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (136, 'ORD-2526767947', 107, 2025-01-07 13:01:24, 3650.77, 1569.62, 313.21, 'shipped', '{"city": "Williamfort", "state": "South Dakota", "street": "69236 Wise Terrace", "country": "Heard Island and McDonald Islands", "zip_code": "90742"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (137, 'ORD-2991253219', 40, 2025-04-11 13:44:01, 3437.24, 2376.60, 92.13, 'pending', '{"city": "Blackburnberg", "state": "Kentucky", "street": "3370 Mccoy Springs Apt. 249", "country": "Netherlands", "zip_code": "32930"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (138, 'ORD-693325479', 111, 2024-09-16 02:51:19, 491.86, 3696.59, 811.95, 'cancelled', '{"city": "Martinchester", "state": "Kentucky", "street": "669 April Field", "country": "Gabon", "zip_code": "91181"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (139, 'ORD-8103103846', 144, 2025-03-17 09:30:22, 2812.80, 3353.37, 411.39, 'delivered', '{"city": "Port Travis", "state": "Connecticut", "street": "611 Olsen Grove Apt. 640", "country": "Singapore", "zip_code": "09655"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (140, 'ORD-7285624787', 74, 2025-02-21 15:50:50, 3006.05, 1764.71, 578.33, 'processing', '{"city": "South Ashleyborough", "state": "Idaho", "street": "462 Nicholas Squares Apt. 372", "country": "Bahamas", "zip_code": "26838"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (141, 'ORD-3220863567', 124, 2025-06-12 00:56:18, 1128.98, 550.01, 845.52, 'shipped', '{"city": "Martinezland", "state": "Michigan", "street": "6791 Christopher Corner", "country": "Myanmar", "zip_code": "04389"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (142, 'ORD-5303340258', 72, 2025-02-06 05:11:09, 2874.76, 4038.03, 845.30, 'cancelled', '{"city": "South Carrieview", "state": "New York", "street": "04090 Jason Turnpike", "country": "Saudi Arabia", "zip_code": "62528"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (143, 'ORD-6139456572', 69, 2024-12-23 18:48:53, 154.48, 1373.62, 762.64, 'shipped', '{"city": "Hardyberg", "state": "Alaska", "street": "3566 Theresa Well Suite 107", "country": "British Virgin Islands", "zip_code": "79394"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (144, 'ORD-3500620658', 2, 2024-12-22 20:51:44, 915.21, 724.82, 657.68, 'pending', '{"city": "Ericabury", "state": "Rhode Island", "street": "786 Aaron Route Suite 050", "country": "Iran", "zip_code": "64010"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (145, 'ORD-3410033885', 8, 2024-12-15 01:33:17, 467.87, 2657.11, 376.81, 'delivered', '{"city": "Marisaside", "state": "New Jersey", "street": "1649 Jennifer Ways Apt. 271", "country": "Ukraine", "zip_code": "22528"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (146, 'ORD-4791803264', 41, 2025-04-16 03:07:08, 1856.56, 3610.76, 777.05, 'cancelled', '{"city": "Mirandabury", "state": "Washington", "street": "32116 Ethan Islands", "country": "Papua New Guinea", "zip_code": "34268"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (147, 'ORD-9118636941', 14, 2024-09-23 12:11:18, 786.34, 3774.64, 50.71, 'pending', '{"city": "West Darrell", "state": "Colorado", "street": "53991 Bennett Stravenue Suite 863", "country": "Benin", "zip_code": "15100"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (148, 'ORD-9398060033', 114, 2024-09-15 21:02:07, 3313.07, 2433.45, 442.60, 'shipped', '{"city": "New Elizabeth", "state": "Pennsylvania", "street": "56904 Brittany Field Suite 655", "country": "Botswana", "zip_code": "29617"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (149, 'ORD-1697853760', 132, 2025-02-26 20:06:02, 577.95, 2155.27, 283.96, 'cancelled', '{"city": "Wayneville", "state": "Louisiana", "street": "2437 Hernandez Haven Apt. 095", "country": "Montserrat", "zip_code": "93106"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (150, 'ORD-3559184883', 135, 2025-02-10 00:49:09, 3338.99, 236.63, 395.86, 'cancelled', '{"city": "Evansburgh", "state": "Alaska", "street": "605 Maria Fords Apt. 027", "country": "India", "zip_code": "72320"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (151, 'ORD-5744132833', 2, 2025-04-22 01:19:14, 1030.07, 4727.17, 767.57, 'shipped', '{"city": "Port Sarahport", "state": "New Jersey", "street": "6618 Campbell Fields Suite 125", "country": "Central African Republic", "zip_code": "86305"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (152, 'ORD-2478872199', 84, 2025-01-20 09:30:06, 608.72, 2491.95, 431.22, 'processing', '{"city": "North Cody", "state": "New Mexico", "street": "2333 Michael Walks Apt. 266", "country": "Western Sahara", "zip_code": "24045"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (153, 'ORD-225366046', 137, 2025-02-17 23:03:03, 3521.32, 2506.31, 833.51, 'shipped', '{"city": "Lake Julie", "state": "Wyoming", "street": "626 Austin Garden Suite 749", "country": "South Africa", "zip_code": "91175"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (154, 'ORD-5936078258', 102, 2025-04-04 08:37:20, 4310.20, 221.09, 19.72, 'pending', '{"city": "Hillville", "state": "Pennsylvania", "street": "0111 Tracy Skyway Apt. 099", "country": "Hungary", "zip_code": "24237"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (155, 'ORD-6157507702', 148, 2025-03-11 16:53:46, 2152.13, 2028.07, 640.50, 'shipped', '{"city": "Brownshire", "state": "Ohio", "street": "51826 Phillip Viaduct", "country": "Svalbard & Jan Mayen Islands", "zip_code": "94053"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (156, 'ORD-3234059678', 104, 2025-04-14 13:16:46, 114.07, 1630.59, 801.51, 'cancelled', '{"city": "Lake Evan", "state": "Oklahoma", "street": "92087 Martinez Crossroad", "country": "Thailand", "zip_code": "34155"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (157, 'ORD-3234405592', 93, 2024-09-03 15:28:20, 449.77, 4223.98, 244.07, 'cancelled', '{"city": "East Kevinhaven", "state": "Maine", "street": "458 Rodney Shoals", "country": "Martinique", "zip_code": "86898"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (158, 'ORD-1910918094', 135, 2025-03-13 21:32:34, 402.45, 4353.92, 746.05, 'processing', '{"city": "West Melissa", "state": "Indiana", "street": "585 Hailey Shore Apt. 303", "country": "Netherlands", "zip_code": "18091"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (159, 'ORD-2371125304', 44, 2025-03-19 14:39:56, 391.13, 3169.79, 531.07, 'processing', '{"city": "Ericaberg", "state": "Ohio", "street": "2961 Green Run Apt. 671", "country": "Barbados", "zip_code": "27208"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (160, 'ORD-2772707308', 90, 2025-05-06 05:57:24, 3639.62, 4096.55, 815.21, 'processing', '{"city": "North Joseph", "state": "Ohio", "street": "892 Underwood Island Suite 609", "country": "Poland", "zip_code": "14917"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (161, 'ORD-6650193311', 38, 2024-08-27 09:37:57, 1287.28, 875.76, 153.72, 'pending', '{"city": "Pettybury", "state": "Missouri", "street": "155 Thomas Union Apt. 401", "country": "Slovenia", "zip_code": "14263"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (162, 'ORD-3975575744', 127, 2024-10-09 00:46:55, 2325.13, 2823.04, 579.88, 'cancelled', '{"city": "North Georgefurt", "state": "Idaho", "street": "718 Graves Way Suite 849", "country": "Sri Lanka", "zip_code": "45743"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (163, 'ORD-7944100417', 81, 2025-02-02 23:31:18, 763.28, 350.75, 442.76, 'shipped', '{"city": "Brianstad", "state": "Virginia", "street": "0822 Nicholas Street", "country": "Philippines", "zip_code": "33152"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (164, 'ORD-6909326720', 15, 2025-05-03 06:34:37, 1766.19, 380.21, 462.28, 'pending', '{"city": "Townsendland", "state": "South Dakota", "street": "75784 Cisneros Pike Apt. 414", "country": "Belarus", "zip_code": "10917"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (165, 'ORD-3135124384', 95, 2024-09-07 03:34:31, 4160.17, 392.89, 864.38, 'pending', '{"city": "Rhodesberg", "state": "New Mexico", "street": "014 Stokes Branch", "country": "Malaysia", "zip_code": "65749"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (166, 'ORD-4830513583', 119, 2024-08-07 04:24:24, 2905.84, 4771.62, 739.17, 'pending', '{"city": "New Shaneburgh", "state": "Utah", "street": "068 Sanchez Streets", "country": "United Kingdom", "zip_code": "69119"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (167, 'ORD-966662179', 147, 2024-08-30 23:02:17, 3262.67, 1614.42, 476.15, 'processing', '{"city": "Kevinport", "state": "Kentucky", "street": "85067 Jackson Creek Suite 381", "country": "Afghanistan", "zip_code": "28427"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (168, 'ORD-6738124846', 116, 2024-10-25 05:45:02, 526.47, 4496.64, 344.09, 'pending', '{"city": "North Michaelburgh", "state": "Montana", "street": "807 Brown Avenue Suite 545", "country": "Algeria", "zip_code": "46970"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (169, 'ORD-4730209740', 11, 2025-02-08 21:02:57, 1246.24, 2194.41, 439.98, 'cancelled', '{"city": "Jeremyfurt", "state": "Mississippi", "street": "88261 Smith Trafficway", "country": "Haiti", "zip_code": "39728"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (170, 'ORD-9372400504', 94, 2025-06-12 22:59:02, 1870.53, 1421.64, 409.36, 'shipped', '{"city": "East Ralphmouth", "state": "Arizona", "street": "77225 Smith Ways Apt. 134", "country": "Papua New Guinea", "zip_code": "21513"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (171, 'ORD-1141600678', 86, 2025-01-12 07:44:23, 338.90, 481.58, 678.69, 'shipped', '{"city": "East Erichaven", "state": "Alabama", "street": "725 Shaw Streets Suite 211", "country": "Dominica", "zip_code": "90211"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (172, 'ORD-8813443977', 39, 2025-06-20 01:28:36, 1673.48, 2917.87, 142.29, 'shipped', '{"city": "East Juan", "state": "Delaware", "street": "9067 Campbell Corner Suite 392", "country": "Reunion", "zip_code": "35042"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (173, 'ORD-9652313518', 101, 2025-06-16 11:28:51, 653.47, 3547.08, 85.63, 'cancelled', '{"city": "Johnsonborough", "state": "Georgia", "street": "71892 Victoria Ramp Apt. 312", "country": "Andorra", "zip_code": "56377"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (174, 'ORD-2647707140', 85, 2024-09-06 02:25:35, 4067.79, 3353.88, 829.12, 'cancelled', '{"city": "New Ronaldton", "state": "Maryland", "street": "6843 Matthew Neck", "country": "Ethiopia", "zip_code": "14926"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (175, 'ORD-5856514972', 109, 2024-12-16 02:37:57, 2547.36, 100.97, 309.55, 'processing', '{"city": "South Jackfort", "state": "Mississippi", "street": "50200 Donna Islands Apt. 474", "country": "Gabon", "zip_code": "44316"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (176, 'ORD-479011764', 125, 2025-04-18 13:53:23, 968.11, 4999.88, 155.79, 'shipped', '{"city": "Johnview", "state": "Indiana", "street": "825 Figueroa Lake", "country": "Hungary", "zip_code": "77089"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (177, 'ORD-456836428', 130, 2025-04-03 06:45:31, 3856.66, 4177.25, 883.79, 'pending', '{"city": "Kevinfort", "state": "Wisconsin", "street": "93371 Shelly River", "country": "Martinique", "zip_code": "26977"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (178, 'ORD-3095681282', 34, 2024-08-18 19:11:45, 2990.26, 779.72, 181.66, 'cancelled', '{"city": "South Carloschester", "state": "North Dakota", "street": "68485 West Stravenue", "country": "Somalia", "zip_code": "66544"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (179, 'ORD-93951990', 113, 2025-03-22 11:21:49, 228.03, 1827.85, 719.86, 'delivered', '{"city": "East Samuelhaven", "state": "Missouri", "street": "240 Laura Square Apt. 678", "country": "Slovakia (Slovak Republic)", "zip_code": "74228"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (180, 'ORD-5971064982', 115, 2025-03-25 14:31:56, 1177.67, 1203.45, 965.62, 'delivered', '{"city": "Melissaport", "state": "Virginia", "street": "20293 Natasha Turnpike Suite 884", "country": "Micronesia", "zip_code": "35695"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (181, 'ORD-511545211', 95, 2024-10-27 18:01:14, 3394.75, 2856.39, 441.15, 'shipped', '{"city": "West Morgan", "state": "Arkansas", "street": "340 Sheri Harbors", "country": "Egypt", "zip_code": "84703"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (182, 'ORD-9491759107', 129, 2024-09-15 21:46:05, 2642.02, 4831.68, 817.07, 'cancelled', '{"city": "Jenniferchester", "state": "South Carolina", "street": "595 Miller Squares", "country": "Greece", "zip_code": "39153"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (183, 'ORD-4231665002', 65, 2025-04-01 21:10:23, 270.38, 2408.15, 371.84, 'pending', '{"city": "Lake Juliefurt", "state": "Tennessee", "street": "3424 Amanda Ways", "country": "Trinidad and Tobago", "zip_code": "34231"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (184, 'ORD-1899169638', 73, 2024-12-05 17:11:50, 428.54, 809.96, 449.87, 'cancelled', '{"city": "Port Michelle", "state": "Illinois", "street": "96273 Richardson Neck Apt. 727", "country": "Liechtenstein", "zip_code": "75167"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (185, 'ORD-9364775207', 112, 2024-11-19 07:41:23, 467.65, 4553.42, 816.88, 'shipped', '{"city": "Sanchezfurt", "state": "Connecticut", "street": "2269 Chad Cliffs", "country": "Malta", "zip_code": "95437"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (186, 'ORD-9179596212', 107, 2025-05-20 05:29:37, 275.75, 2515.02, 236.54, 'pending', '{"city": "East Johnland", "state": "Louisiana", "street": "166 Daniel Bridge", "country": "Wallis and Futuna", "zip_code": "19196"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (187, 'ORD-4150487885', 58, 2025-06-05 05:39:34, 150.66, 4654.82, 839.33, 'shipped', '{"city": "Ochoaport", "state": "Michigan", "street": "513 Timothy Port", "country": "Cape Verde", "zip_code": "63272"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (188, 'ORD-1047151089', 36, 2025-02-28 20:52:49, 201.13, 4587.81, 472.98, 'processing', '{"city": "East Andrewchester", "state": "Missouri", "street": "810 Curtis Hill Apt. 862", "country": "Guinea", "zip_code": "19817"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (189, 'ORD-7109736800', 115, 2024-10-28 12:14:31, 3080.59, 4530.23, 19.98, 'processing', '{"city": "West Sandraland", "state": "Arizona", "street": "172 Jeffrey Haven Suite 195", "country": "Canada", "zip_code": "79734"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (190, 'ORD-5059762573', 141, 2025-02-23 19:17:05, 4701.73, 3048.31, 423.83, 'shipped', '{"city": "Sarahland", "state": "Alabama", "street": "262 Weber Heights Suite 147", "country": "Slovakia (Slovak Republic)", "zip_code": "19983"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (191, 'ORD-2816872014', 78, 2024-12-04 03:50:57, 618.02, 1199.81, 639.31, 'cancelled', '{"city": "North Marcus", "state": "Florida", "street": "7711 Moyer Harbors", "country": "Seychelles", "zip_code": "24339"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (192, 'ORD-5948604439', 17, 2024-12-03 19:05:08, 563.18, 4526.68, 597.14, 'pending', '{"city": "Ryanfort", "state": "Ohio", "street": "7695 Leah Shoal Apt. 668", "country": "Swaziland", "zip_code": "70783"}', 'debit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (193, 'ORD-5283301624', 37, 2024-09-03 06:13:14, 1463.45, 17.81, 353.46, 'cancelled', '{"city": "North Brian", "state": "Minnesota", "street": "931 Michael Ford Apt. 587", "country": "Thailand", "zip_code": "47799"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (194, 'ORD-4893467877', 48, 2025-01-27 13:58:39, 3325.21, 437.21, 974.67, 'pending', '{"city": "Lake Janefurt", "state": "Washington", "street": "633 Brian Dam", "country": "Qatar", "zip_code": "03954"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (195, 'ORD-8439237908', 100, 2024-12-24 03:11:42, 4367.92, 227.24, 387.49, 'shipped', '{"city": "North Dylan", "state": "Georgia", "street": "191 Monroe Ways", "country": "Ecuador", "zip_code": "10854"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (196, 'ORD-330992932', 5, 2025-03-10 20:01:06, 1791.90, 347.12, 241.88, 'pending', '{"city": "North Nicole", "state": "Arizona", "street": "27284 Jenkins Junction Suite 041", "country": "Sao Tome and Principe", "zip_code": "79691"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (197, 'ORD-9335455876', 35, 2024-10-03 01:24:21, 231.24, 2734.61, 813.69, 'processing', '{"city": "West Teresa", "state": "North Dakota", "street": "6784 Fletcher Manors", "country": "Zambia", "zip_code": "49988"}', 'bank_transfer');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (198, 'ORD-9127378252', 123, 2024-10-23 01:33:53, 3162.36, 4059.37, 64.04, 'delivered', '{"city": "Wilcoxburgh", "state": "Arkansas", "street": "036 Lynn Points Apt. 775", "country": "Oman", "zip_code": "49191"}', 'credit_card');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (199, 'ORD-1822019158', 76, 2024-11-14 14:40:46, 1015.94, 3957.63, 885.90, 'shipped', '{"city": "North Jasontown", "state": "Wisconsin", "street": "15950 Julian Plains", "country": "Comoros", "zip_code": "41017"}', 'paypal');
INSERT INTO orders (id, order_number, user_id, order_date, total_amount, tax_amount, shipping_cost, status, shipping_address, payment_method) VALUES (200, 'ORD-2369496447', 132, 2025-04-06 17:03:47, 1997.14, 4078.88, 473.92, 'pending', '{"city": "West Alanstad", "state": "Wisconsin", "street": "41990 Williams Island", "country": "Indonesia", "zip_code": "37516"}', 'debit_card');


-- Table: products
-- ================================================

DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    id INTEGER NOT NULL DEFAULT nextval('products_id_seq'::regclass),
    sku CHARACTER VARYING,
    name CHARACTER VARYING,
    description TEXT,
    category_id INTEGER,
    price NUMERIC,
    cost NUMERIC,
    stock_quantity INTEGER DEFAULT 0,
    weight NUMERIC,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Data for table products (300 records)
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (1, 'SKU-67137866', 'Food & Beverage', 'Sell rise wind reflect best imagine. Big space change onto him only system.
Charge leg those behavior. This space pressure shoulder claim.
Yeah participant model shoulder language capital fact. Task issue three similar hold decade particular avoid. Note yes best address.
Test something time material lawyer college fast. Evidence guy become condition.
Worry without shake kind under. Will major guy expert. Tax true can happen suddenly weight.', 12, 862.27, 48.76, 6, 13.734, False, 2025-01-03 20:24:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (2, 'SKU-9795032', 'Furniture', 'Them protect give life movement stand. Beat rule true two.
Husband ask garden page defense. Boy lawyer nation we certainly degree nothing. Similar artist speak smile without degree deep age.
Edge compare center event bank. The modern prove else store begin top. White father cup walk loss movement.
Great realize home act situation others. Reveal official certain professional.
Character learn challenge. Box wide image minute about late. Plant police official already.', 12, 437.51, 400.62, 8, 44.742, False, 2025-04-10 19:08:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (3, 'SKU-61202946', 'Tablets', 'Goal stock international wind from unit. Into computer organization myself high suddenly read. Plant reduce visit town between because.
Power pattern in market. Until between know ok allow face inside development.
High crime light buy whose trial include. Account hear difference exist they enough. Pull above training allow ago so.
Fish color occur involve new hot pattern hotel. Soon official can. Within community tough military join between.', 11, 973.74, 496.70, 8, 18.431, False, 2025-02-28 22:14:30);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (4, 'SKU-10572666', 'Furniture', 'Agent safe work play sing cost. Father movement early sister skill. Process ever various physical point.
Book until but center. Thus behavior management guess stuff. Beyond somebody including main personal decision. Heart finish traditional speak conference act.
Piece talk bring garden get yet outside. Citizen score unit.
Ahead age memory charge term boy describe foreign. Base reality call event current.
Remain present level speak job watch. Economic cup suffer response which.', 17, 267.45, 83.53, 7, 4.038, True, 2025-07-16 11:49:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (5, 'SKU-84919350', 'Accessories', 'Cold almost memory only fall step population. Good air conference follow so group authority.
Certain fire act read response degree. Somebody together no history own money bill. Respond watch space provide off.
Fish floor culture sort material wrong. Budget laugh over option door again. Popular task write.
Capital whom already mouth month. Population attorney believe sort rich ever. Hundred news finish partner hotel recent.', 6, 545.92, 321.89, 2, 16.463, True, 2025-07-30 13:23:11);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (6, 'SKU-92374176', 'Food & Beverage', 'Third amount answer fight enough.
Establish color case leave call technology. Thousand whole including land business month official product. Focus room difficult enough fast. Good structure drug positive.
Avoid manager defense provide. Stand could bit decade opportunity month teach.
Pretty summer black candidate true history laugh. Message sister could everyone clearly film thank possible.
Then seat drive thus cost agreement product. Goal brother nearly great deep however issue.', 10, 446.47, 717.94, 3, 34.519, False, 2024-11-13 03:48:28);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (7, 'SKU-32046782', 'Laptops', 'Big difficult per respond hot big safe. Manager commercial data PM relationship.
Behind me red. School system reach color race coach forward.
While program into again. Thing color set act goal. On major easy body standard note wrong.
Me sense simple beyond sound friend make. Wrong either main hair add good.
Simple tax total other both rate rock. Challenge improve detail. Ground all officer receive.', 15, 43.31, 870.16, 6, 30.781, False, 2024-09-18 12:55:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (8, 'SKU-58177965', 'Gaming', 'Why society eye wide material rate letter. Model face newspaper class. Explain son administration American executive or apply.
Involve produce a. Case these size maybe when.
West require central run. One ball despite list great speech. Institution whom better end few financial.
Quickly follow official raise current career. Current figure father until leave contain site. Benefit money reason mean rate group.', 9, 639.82, 791.68, 1, 3.845, False, 2024-08-04 02:19:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (9, 'SKU-62117013', 'Fiction', 'Stuff be establish worry blood organization state. Loss former article science purpose school apply. Might no whose carry time.
Pick rest view south perhaps. Boy a page building best.
Listen strategy kitchen argue. Feel low contain dog.
Start race teacher pay it. Continue stand price. Memory record customer lose.
Where manage property hospital. Less spend challenge exist.
Hope oil alone practice price know traditional. While life rich everybody word group.', 13, 363.94, 801.29, 3, 47.644, False, 2025-04-14 16:54:33);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (10, 'SKU-24209460', 'Sports', 'Simple moment can food western give pay. Attack ahead run discuss professor material. Food discuss sign true somebody black thing.
Two artist economy also seek kid. Paper subject type fly recognize help. News cultural make quickly different score its.
Beat agency where benefit almost. Throw growth impact national. Future radio whatever rock.
Couple debate still may ground tonight table. Keep personal them notice. Site fear brother discover.', 20, 678.40, 438.73, 3, 3.455, False, 2024-08-24 20:25:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (11, 'SKU-18695003', 'Magazines', 'Stage form serious treatment artist management south. Toward reflect she along wonder wear our.
Thought long can rich. Along medical practice it. Sit theory direction use ago. Move team radio scene need.
She receive involve interview case just.
Goal gas truth draw begin act. Section thousand soldier nothing yard address. Spend baby camera Congress analysis. Own three your can huge price.
Economic myself manager same. Today teach kitchen few happen necessary.', 21, 366.96, 383.47, 10, 1.716, True, 2025-05-10 07:30:17);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (12, 'SKU-19053714', 'Sports', 'Recognize practice law box material.
Everyone his still be everything.
Manager television his and day continue. Mouth produce all several visit travel. Two traditional special opportunity serious game. Its into role save arm body hold return.
Less occur nothing million class high second. Car address son week beat.
Fast number although ever environmental economy president. Activity fill produce structure summer kitchen admit across.
Lose such design around voice everybody.', 22, 450.47, 371.59, 8, 38.178, True, 2024-11-01 19:38:55);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (13, 'SKU-27386042', 'Shoes', 'He state indeed politics then central force. Friend impact present likely wind perform. Happy fact change option.
Deep finish respond score situation require vote her. Allow risk high young bad back very different.
Piece safe much building these sometimes parent. Minute first crime offer treat forget sometimes. Discuss fire win realize knowledge whatever.', 5, 529.93, 398.63, 5, 12.556, False, 2025-04-04 11:23:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (14, 'SKU-26589097', 'Home & Garden', 'Administration building enjoy never us sea call. Street agency cold.
Method more hold institution. I news Republican budget.
Participant blue reveal available TV wear treat piece. Eye local care contain she trouble. Base time order have power here just.
Evidence significant discussion manage answer military modern meet. Expect himself serious well among war. Issue everything they fire girl.
Explain main difference college. Writer send under project cell.', 1, 735.93, 499.54, 7, 45.686, True, 2025-03-11 14:29:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (29, 'SKU-1572026', 'Fiction', 'Low gas pick stage officer later Democrat. Enjoy key seat pretty method front you control. Southern maintain nature professional property garden.
As half politics who call. Window store build require call. Film job worker bar term measure.
Crime style develop admit safe government over. None most another mouth. Discover water most hear beyond close plant.', 10, 614.81, 94.33, 3, 29.631, False, 2025-06-17 04:33:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (15, 'SKU-57244204', 'Home & Garden', 'Call law truth respond try build threat. Enjoy ten year rule bring government bad. Road force medical everybody piece.
Religious fire under item. Fish success produce there along play account. Only the detail cultural.
Machine cost market capital. Week tax see about. Make particularly report although.
Herself on point machine prevent conference feel discussion. Property make picture our myself.
Despite while to shake. Wide foot production break let five.', 9, 775.18, 704.33, 4, 49.819, False, 2025-05-28 12:31:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (16, 'SKU-43378098', 'Food & Beverage', 'In speak interesting end area magazine. Fund stand final important occur.
Deal personal way party form painting after. Sort bed relate.
As any decision movement world study how. Face claim hear including need. Vote already after wait bill.
Amount executive agency place read almost seek. Pretty capital scientist establish be available. After sea must try believe open.
Story teacher size interesting sea. Ever dark enough prevent likely. Involve develop image everything expect.', 23, 916.55, 491.70, 2, 6.873, True, 2025-03-07 14:40:40);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (17, 'SKU-22717117', 'Books', 'Order base idea study model style set. Should edge find full.
Focus north image. Environmental decide none.
Matter where dog leave lot never science. Tv international back camera. Class security coach.
Although interest color sort. Cause them industry across brother yet result. Mission past he practice center.
Sort weight he page line. View until result system career. Resource listen fish conference like year accept.
Really Mrs former article light. At player third general.', 15, 173.48, 713.65, 2, 40.545, False, 2025-05-26 15:42:03);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (18, 'SKU-54125762', 'Bathroom', 'Must process back check room evidence enjoy. Camera mission population him.
Painting whom say pattern training decide able discussion. Before sound chair close themselves. Back wide case southern international line.
Service drive hotel similar relationship great stuff. Most third success western watch street.
Night majority smile rate newspaper itself. Concern term talk side generation interest.', 11, 668.17, 709.82, 9, 27.154, False, 2025-07-28 00:28:15);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (19, 'SKU-63190952', 'Garden Tools', 'Lawyer community seek positive nation billion hard party. Relationship computer surface bar. Argue PM artist best. Everyone system pretty scene four public tonight.
Reveal hand add professor indicate property article cover. Challenge entire common and part read important.
Event go game nothing recent.
Because truth consumer beat fish phone after. Small design hear ball. Film race wall ten section.
Apply relationship concern cell firm. Structure evening current without else.', 10, 851.50, 712.09, 3, 39.705, True, 2025-02-17 02:53:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (20, 'SKU-28282626', 'Women''s Clothing', 'Life all boy probably cost. Level follow nor probably.
Red picture thank account instead friend.
Tree fill level control. Keep pattern order.
List during rich over lot husband. Wife theory shake. Blue international especially officer or clearly coach.
Whole wall cup win sell candidate four whether. Finally she soon learn.
A challenge third feeling ball door data. Right child new simply.
City beyond near hour defense line heavy.', 8, 122.24, 201.78, 3, 11.913, False, 2025-06-17 11:58:57);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (21, 'SKU-213612', 'Men''s Clothing', 'Seem trip population catch could deep itself fund. International expect hit start. End western conference. Radio strong let bar rather big.
Claim can medical. Activity president prove institution approach interesting score. Page sort late health.
Such will born condition interest service. Character front various opportunity. Method pass the itself let.
Test least anyone out.
International push short age environment. Ground adult foot player other. Rule most how compare movement call.', 1, 361.53, 572.70, 8, 40.203, True, 2024-12-28 02:32:02);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (22, 'SKU-68804339', 'Kids'' Clothing', 'Until see institution against wear either. Student item bring court.
Past much soldier reason any. List set join section sing everybody provide.
Travel question evening imagine affect increase. Ever leg so play. Determine adult foot as. Rock participant leave inside organization.
Little newspaper gas floor state charge. Decision recently pull eight allow system whose. Main world bar security morning fight seem later.', 5, 612.33, 87.13, 5, 19.968, True, 2025-07-03 16:14:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (23, 'SKU-21356391', 'Educational', 'Impact seem industry out floor guy black. Maybe mouth different identify series experience. Church them hundred about stop several prevent.
Oil individual industry country ahead difference. People your outside rule watch foot economic notice.
Weight age over smile. Need tell sure claim hard themselves. Line require current car.
Debate leave each. Kitchen drop computer left political sound study the.
Left while according allow quality. Yet television audience indicate employee respond building.', 24, 479.18, 411.38, 7, 41.185, True, 2025-06-06 17:56:21);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (24, 'SKU-64772268', 'Books', 'Best politics available tonight man. Serious garden ready former late.
Every along cause miss ago they nor. Fill respond nothing fight require.
Season reason chair factor. Either direction surface on chance activity.
Seat you image peace color general choose. Fire hear tend magazine college moment compare. Add water garden finally difference everything.
Ground least tree trade style. Together scientist hair allow phone weight medical.', 5, 972.40, 642.69, 8, 23.345, False, 2025-05-07 09:18:58);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (25, 'SKU-61212149', 'Women''s Clothing', 'Without entire everyone. Safe true town car few.
During seven local better think. Five plant cultural.
Bar culture my Democrat maintain notice. Involve toward result kind politics open play sense.
Senior over manage computer medical.
Week federal test eat every. Me personal born series consider according throw. Like clear assume it fight understand kitchen.
Cover board discussion film. Floor most bill feel participant. Public food court how commercial citizen production.', 12, 129.20, 829.22, 9, 32.026, False, 2024-12-17 02:44:57);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (26, 'SKU-86676830', 'Toys', 'Short affect region decade respond far health. Into him newspaper school something pay.
Blood during for look return. Weight water sit hope where religious economic. Only arrive argue garden Mrs just exist line.
With run station them operation off. Because early of several end most fact.
Sign attention skill represent.
Toward knowledge this contain life leave. Current will else page usually cell. Interview south something story art writer.', 25, 966.29, 433.18, 1, 41.586, True, 2025-05-20 19:07:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (27, 'SKU-9809109', 'Women''s Clothing', 'Letter threat yes charge form. Possible fund month realize. Threat husband family perhaps hope across.
Character talk once should mother president. Show off great they test. Country challenge final beyond.
War always camera give attorney that up probably. Field interest even view describe. Agree there want but way agent.
Any just cup side opportunity by. Medical official might clear.
Wait scientist group yet. Course world son growth effort born.', 5, 304.82, 162.80, 4, 17.367, True, 2024-11-16 11:23:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (28, 'SKU-97929161', 'Women''s Clothing', 'Cell eat north. Million cell like although. Sort term produce he increase church common view.
Half understand skill air. Fill personal training enter fly.
Agreement like same certain imagine much.
College beyond give development information at why. Work task Mr care owner PM find. Tonight either follow music whatever protect benefit. See system cultural despite candidate walk difficult.
Response executive past economic. Continue process forget wind property.', 10, 846.08, 251.35, 9, 13.795, False, 2024-12-05 01:03:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (30, 'SKU-21508787', 'Shoes', 'Skill position hospital cover strong audience. Cell husband rise one public.
Central every force PM minute modern. Out discussion just state must particular child they.
We American study eight phone. One then reality some serve different. Become rule where ten.
Student white instead point tend exactly right. Toward policy forget project economy.
Actually require magazine one. Opportunity program billion sit remain. Parent not parent that property among blue.', 5, 172.03, 624.85, 10, 16.947, False, 2025-07-03 02:25:23);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (31, 'SKU-70164383', 'Decor', 'Spend physical sing protect agent note.
Watch better turn soon rock support effect stand.
Wind eat land answer leader yard. Shoulder civil next tell possible. Send sit common matter become goal.
First figure trial bed image. Market control him enter religious go south time. Where follow born ok.
Fast nice concern peace away behavior Republican. System certainly future government card history. Party wife food different step.', 19, 42.15, 863.91, 2, 2.369, False, 2025-01-09 18:30:28);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (32, 'SKU-74668321', 'Fiction', 'Court control million hundred offer total hit. Religious word sound enjoy have. Floor ground when care team.
Often benefit true world remain movement bit. Direction give reduce with start difference especially student.
Just opportunity ask yet against large practice time. Test challenge radio assume rest now water. Require make region.
Democrat laugh Mrs push form now. Watch certain much race fire according participant.', 25, 577.19, 651.47, 10, 20.888, False, 2025-02-02 00:38:45);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (33, 'SKU-18590430', 'Fiction', 'Benefit great religious these. Before employee customer goal positive bank later. Model after paper word.
Believe ability world actually force fill. Nor teacher western country per consider despite.
The tree outside off. Relationship they concern chance standard air. Very thousand soldier.
Various blue raise operation cold. Marriage page young turn.
Story six want protect assume east center. Could identify group true TV specific travel. Better mind professional fly month offer mother hour.', 1, 498.54, 627.53, 5, 32.131, True, 2024-10-13 19:52:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (34, 'SKU-11970543', 'Food & Beverage', 'Security number community finish answer agreement whom his. Who appear stay them school model.
He recognize treat better wear throughout Republican. Research manager number party.
Deal ready under above drive sport.
Would step head study. Choose out perform. Think institution now tell phone.
Important act statement help successful. Stage major outside phone house.
Production development point boy. At Mr cold science western resource reason. Movie expect now board budget.', 16, 245.63, 807.53, 7, 14.942, False, 2025-03-28 18:03:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (35, 'SKU-49781610', 'Books', 'Kind shoulder production mean. Shoulder right analysis add check. Two glass customer popular hospital.
Measure different physical from return. The attorney early.
News century who arm range. Million admit result right focus although. Range accept about around.
Build different pick nor available power treat. Population executive pattern last security raise partner. Woman PM look together lawyer these.
Expert room white home. Think happy again south century.', 23, 60.85, 440.16, 8, 23.276, False, 2025-04-14 20:12:37);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (36, 'SKU-83064164', 'Smartphones', 'Nature shake impact popular degree center board. Feel strategy simple perhaps anything describe necessary. Process view it wall.
History project event second nor.
Offer song character first early school. First usually partner same then put skin.
Across television apply. Finish top data character.
Subject guy training on stock. Full compare field sort civil thing clear.
Travel important no pick record example summer. Wish professional chair knowledge sense.', 20, 144.52, 861.61, 6, 36.737, True, 2024-09-03 19:12:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (37, 'SKU-49656286', 'Bathroom', 'Career feel hour change. Which fly represent we bar.
Administration through individual college surface court exactly. Toward age five cold power red enjoy. Front evening yet prevent process four. Candidate within person.
Few current like. Along public recent friend sort table. Imagine garden wall rest need major.
Tree try be program. Technology time age campaign seven drug.
Assume occur down beautiful away rich. Thank pay choose personal the leave.', 12, 975.39, 131.63, 6, 25.798, True, 2025-05-03 20:06:00);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (38, 'SKU-66478091', 'Home & Garden', 'Light rule option team. Continue according compare culture century my. Record reflect away cost focus. Class play or own media.
Interview station save most pressure. Example claim article management total.
Sense involve purpose together knowledge with purpose five. Recently painting where notice road five.
Have feel major national seat direction color. Important they food someone war idea. Laugh center seek information agency cause first.', 11, 242.49, 123.40, 8, 12.471, False, 2025-04-17 08:27:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (39, 'SKU-8020907', 'Home & Garden', 'At follow live eye. Million management describe make whatever. City piece range investment business can example right.
North list adult have early war. Travel total plant top live.
Future soldier recognize top whole sit occur. Remain participant spend eat none.
Memory believe seek perhaps ball make.
At hope cover show Republican. Summer arrive east plan force station. No situation what machine fire third customer. Whatever our build safe save.', 2, 290.92, 384.76, 10, 20.965, True, 2025-01-29 08:23:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (40, 'SKU-19812515', 'Bathroom', 'High church know finish view lay cup paper. Clear campaign what buy test. Local center story heart agent its food.
Party set poor food series always. Argue response car ask attack charge mission.
Senior win full include. Manage nation modern politics.
Nature become debate city. Dinner argue raise agency poor. Long among serve wear west.
Floor hold plant how member face age. Nearly always operation decade old according.', 6, 813.66, 933.81, 6, 9.573, True, 2024-10-16 19:34:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (41, 'SKU-43896992', 'Toys', 'Budget experience agreement owner prepare memory. Daughter both hold blood value day.
Strategy purpose though stand guess. Possible discover three. Describe agency actually stop team.
Water home force worker own close man. Others some project visit back blue a.
Anyone action ever a knowledge rock which best.
Position wife score health evidence. Father alone build. Enjoy us thought song.
Try season radio air. Company both right lay though reason event.
Look rule check assume question air market.', 16, 995.96, 467.34, 5, 24.919, False, 2025-03-06 20:35:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (42, 'SKU-94347940', 'Books', 'Resource score expert because happen. Name health top risk must fly police. Community I level girl factor sport.
Imagine which beat education case under population. Send technology clearly amount media teacher person. Game plan seat surface off with society station.
Statement thing wrong name. Billion about various professor clearly dinner report. Major for student health view mission.', 13, 505.93, 966.71, 4, 29.209, True, 2025-06-14 02:29:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (43, 'SKU-25636468', 'Clothing', 'All building control.
Effect week instead group. Action our gas heart field people.
Order quickly with matter goal eight list something. Show institution onto thing we range yes. Although maintain town little myself bar.
Lawyer see drop worker. Follow need region. Describe improve act campaign television sit very. Attorney Congress ever north soon movie.
One recently make total fall.
Face former body. Why baby lot eat.', 2, 282.07, 597.92, 8, 14.359, True, 2025-01-11 08:42:39);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (44, 'SKU-63573301', 'Electronics', 'Job reduce at beautiful there.
Husband try trade then building class now. Land you health enjoy at. Old break always dark.
Second hospital head member. Both program one.
They case TV team song.
Long degree common need phone teach audience. Tax certainly set local.
Clearly phone including personal visit still image. Amount fly house cover risk health.
Student different traditional look we meeting image the. Drop miss market avoid. All at be through certainly political hard hotel.', 4, 431.49, 882.56, 6, 38.216, False, 2024-11-13 22:45:37);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (45, 'SKU-36406719', 'Laptops', 'Message fine town trade not give fill stay. Put everything our prove could party skin.
Reach gun myself fly something. Minute bring reveal factor east our plant front.
Early machine establish nothing Mr chair. Author buy heavy nearly hotel at speech effort. Lawyer yard on everyone note current anything.
Word other live hit budget Congress guess soon. American audience blue. Environmental six understand rather daughter through note.
Front person everyone involve.', 2, 401.18, 570.71, 4, 18.190, True, 2024-10-19 16:15:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (46, 'SKU-72707256', 'Food & Beverage', 'West before science. Special buy east image drug. Close community detail blue draw final often outside. Land discussion suggest impact know character.
Seek age share day pull job themselves garden. Material past study. Day certain back student raise collection identify design.
Ever resource together here there whether. During recently laugh son home generation herself. Job knowledge interest join give especially treatment.', 3, 386.96, 450.90, 9, 14.058, True, 2024-11-07 00:39:40);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (47, 'SKU-10637474', 'Accessories', 'Laugh fall teach everything trouble. Important coach at the per. Pressure six west walk compare nature walk.
Admit which owner baby significant. Stage condition buy leg set.
Move cost skin for. Short message again mean.
Career answer choose car technology strong. Situation left lawyer report require class paper.
Work career expert more.
Nearly risk threat level positive mind. Officer study if edge view cold teach call. Deal outside happen.', 22, 611.43, 129.53, 2, 19.756, False, 2025-06-04 19:04:02);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (48, 'SKU-18769693', 'Furniture', 'Each administration dinner keep main letter. He daughter candidate where early certainly policy.
Hear go travel thought the. Our great mention local.
Good cover two coach. Certainly represent especially agency. Piece he large free party.
Force happy song one third serve item method. Rock not attack why usually help produce. Rule play century several cultural pattern.
Detail analysis activity card industry create. Interview nothing wrong decision.', 11, 558.27, 366.24, 3, 10.033, False, 2024-12-24 07:13:22);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (49, 'SKU-62938222', 'Women''s Clothing', 'Next threat sport former professor money property. Mind everything order to difficult against low foreign.
Material right identify weight feel. Blood challenge difference situation thing. Less check better my guy.
Note federal drug performance way production. Unit arm image it increase within. Visit brother dog these man when.
If support expert particular close. Our order table beyond. Someone across music manage. Various soldier recently charge.
Likely allow fact.', 13, 500.57, 46.26, 3, 35.708, True, 2025-03-28 19:07:03);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (50, 'SKU-70610268', 'Furniture', 'Expect assume paper employee poor record benefit paper. Allow system professor reason special.
Fill president spring individual us some suggest. Decision leave reflect already arrive themselves. Blue large chance available.
Often responsibility itself but popular wall. Role few remember time prevent hair hospital. At all table edge cost marriage.
Last staff seat religious probably when. Test contain than clearly economy behavior then. Challenge this drive page whatever trade.', 16, 519.81, 149.79, 9, 7.075, True, 2025-04-23 00:13:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (51, 'SKU-88404605', 'Decor', 'Most threat year partner partner. Show rule always who opportunity face. And forward imagine phone social listen there.
Occur type strong development enter through system stage. Effect enter most American weight last however involve. Sort event sport national.
Maybe weight some. Shoulder professional market oil move. Explain break dog writer night forget nation.
Rate bag positive. Again candidate see election price public indeed.', 20, 319.21, 393.56, 10, 36.992, False, 2025-02-25 09:36:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (52, 'SKU-62451136', 'Food & Beverage', 'Loss pass size green. Good hold country war. Treat per wide.
Class garden miss ready. Long under place ahead table.
Southern simply I cold. Point similar security at year dinner prevent tree. Newspaper leader focus hard tonight already could.
Admit professor head full see account. Television be successful organization no bring. List network necessary seven.
Specific skill point early Mr international although blood. Professor your receive staff yourself.', 19, 337.03, 828.45, 9, 24.543, False, 2025-03-22 15:01:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (53, 'SKU-13438230', 'Shoes', 'Believe enough free thousand. Office old bad any. Success nearly must teacher speech.
That national trade price beyond idea us. Try information price especially appear. Behind war about through.
Special image blood city vote time easy.
Continue truth red billion. Like rock call. Draw impact race themselves office role success.
Draw involve party home stay fall carry. In official especially pattern threat religious effort painting. Within if course.', 10, 475.41, 17.62, 6, 33.723, False, 2025-01-02 01:53:33);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (54, 'SKU-17845866', 'Gaming', 'Where off prepare response stop. Including game language.
Than foot in process. Kitchen cut play deal good.
Major event any able less article threat. Security modern data book.
Exist computer shoulder list. Assume lawyer field difference cut tell style.
Civil determine toward admit doctor. His worry necessary politics certain environment he. Ready even probably son second.
Note those drop executive.
Task off under two physical within about. Force ready network.', 19, 308.37, 898.86, 1, 29.886, False, 2025-05-23 12:33:17);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (55, 'SKU-32368904', 'Health', 'Manage issue none ready billion time. Improve analysis level movement school. Race wish kid career.
He already activity onto build. Poor threat throw behavior type.
Behavior economy our second. Analysis ready must price receive. Unit majority yeah. Thought beyond mean director offer a.
Send news clearly school wonder occur. Court state doctor and conference. Culture far article last peace.
Rise right happen series.', 21, 783.11, 776.38, 10, 11.454, False, 2024-10-29 19:40:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (56, 'SKU-93910471', 'Clothing', 'Require research this most too. Together true worker though church young mouth note.
Common student knowledge firm paper unit. Cultural far significant. Until themselves break reason too discover record.
Look training oil scene career military much. Sometimes drive anything teach myself.
Much base modern behavior end. Carry condition into sure day sort determine.
Challenge kind instead plant bag set leave. Yeah front almost activity agree.
Base close score.', 19, 480.96, 524.70, 10, 38.753, True, 2025-06-17 22:24:40);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (57, 'SKU-38785862', 'Tablets', 'Small fire light medical level analysis any product. Help PM become rich every. If none dog chance.
Direction focus product hand start size heart. Need always like.
Drive own pass least great. Sign single well. Continue ask environmental another business hot strong.
Trip school energy safe while popular natural. Marriage us middle her shake month ask.
Choice assume recent people far. Miss population project film.
Again these series candidate. Issue bit whether edge left American hope.', 5, 821.83, 242.95, 10, 47.415, True, 2025-05-28 14:45:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (58, 'SKU-30315274', 'Home & Garden', 'Drop recently million store every rise. Letter story article read.
Rather arm table draw trouble.
Create moment onto third business rock. South bed represent lawyer.
Name paper cup order. Quickly manage care popular yourself always image alone. What truth partner measure.
Believe whether teach single result modern. Action continue star. Only free increase.
Study model actually read. Line reflect enough exist without build. True think quite hot particular generation.', 7, 19.92, 314.38, 3, 20.707, False, 2025-01-06 22:57:45);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (59, 'SKU-26132987', 'Beauty', 'Walk paper media available. Every front baby effort already second room.
Movie wait amount happen again society down. Investment whom season mind benefit second.
Voice want themselves. Minute data hospital this. Stand several hit rate.
Wait defense well should effect future. Stage meeting contain.
Magazine suggest interesting no. Perform worker story face. Break fight never.
Sister garden down television tree say more. Animal do hear rich apply project. Reality adult state medical year oil ask.', 14, 502.31, 611.86, 8, 43.654, False, 2025-05-26 12:20:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (60, 'SKU-83816810', 'Comics', 'Thank prevent store politics service second. Bed mission certain situation often PM notice. Form bill again matter.
Peace window create compare couple continue sister. Family center wide identify nice.
Performance age newspaper choice policy lead. Win air kind see finally wall.
Parent for production traditional practice together minute. Serious structure wonder stock today whether thought.
Total not its air. Image several name chair.
Situation him her imagine. Type describe no speak.', 24, 63.22, 138.94, 4, 28.088, True, 2025-03-17 23:46:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (61, 'SKU-41707179', 'Non-Fiction', 'Personal American ahead where long. A property message outside traditional. Artist area street shake mean avoid.
Friend wide take answer at month partner evidence. Picture available scene approach imagine.
Miss the we politics phone anyone happy point. Admit manager kind example class.
Rise several in candidate. General new begin their. Step type type word not usually at sing.
View push enjoy wife cup law.
West fire resource commercial. Trouble husband level until less daughter.', 16, 525.95, 314.44, 3, 23.037, True, 2024-12-25 19:14:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (62, 'SKU-16275807', 'Kids'' Clothing', 'Language through nation film or. Ten follow cell how.
Win behind every. Door daughter economic. Huge move until toward.
Color cost add claim begin man star. Still bill cover mind wind commercial national. Six rather just serious term discuss state.
Summer concern race five. Full occur last.
Size open rest investment race yes law.
Team market too million space team. Half able music.
Congress pick foreign city. Quickly process address friend writer view.', 11, 546.72, 676.19, 5, 30.543, True, 2025-03-06 07:22:11);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (63, 'SKU-79273380', 'Beauty', 'Dog perhaps my situation test. Camera truth surface sometimes. Reality discover success item rest respond economy why.
Think front save mention picture. Exist later nation leader.
Begin type dog name language local.
Ago past ever sister. As physical wind manager mother his change perhaps. Media responsibility child street floor officer.
So mother race. Human control personal. Happy receive third professional test.', 8, 279.72, 299.20, 5, 38.582, True, 2025-04-24 05:46:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (64, 'SKU-71498200', 'Educational', 'Smile store develop wait national. Various future clearly bag quite foreign mouth. Reveal usually concern war home why.
Watch develop reason gas part rather. Difference yard mean nice.
Hand weight majority enjoy hit sure. Administration fly maintain quite station difference. Fill perhaps there throw station.
Trial out close current. Old especially also stuff decision film.
Law force foreign blue rock. People Democrat information road week best. Language fish administration per well change.', 7, 690.54, 489.51, 8, 17.505, True, 2024-11-15 07:06:25);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (65, 'SKU-48450800', 'Decor', 'Suddenly money task give clear. Very newspaper tree simply.
Western tell on indeed. Much evidence television catch relationship member work. Must fund open who someone.
Explain maybe fight pass budget bar really world. Carry surface think. Choose fill police.
Authority door poor stay yard. Son than attorney accept. Lose miss plant international scene radio. Field surface modern him only.', 24, 274.18, 122.75, 9, 19.047, True, 2025-05-03 13:50:17);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (66, 'SKU-72929177', 'Tablets', 'Couple as customer century. Phone perhaps arrive.
Mind indeed majority daughter.
Generation mouth short identify relationship professor computer. Tonight lose fly section. No enter career choice number allow.
Bed staff talk score him price drop bill. Near consider keep.
Compare lead Democrat kitchen response describe north. Whom what unit for common office note pass.
Western run son price. Away field network century to foot hair who. Talk music floor vote environment business right.', 12, 954.64, 804.80, 5, 2.199, False, 2025-07-17 17:27:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (67, 'SKU-79979778', 'Educational', 'Treat responsibility Democrat remain stage catch week. Drug chance speech sell better soldier however. Nature community third.
Major specific rather letter me tell just. Really reveal these project group.
Hour article study seek young shoulder dark. Within door hold bank of.
Body at strong clear decide road. Age chance officer single. See professional begin current everyone test memory arm.
Office yeah bar. Matter participant boy huge plan rule break church.', 3, 347.01, 442.93, 5, 37.392, False, 2025-05-18 19:16:35);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (68, 'SKU-97936117', 'Beauty', 'Family court herself. Movie produce lay theory specific.
Change size computer bed. Smile raise personal. Two teacher office force.
Others heart admit statement. Red happen whose return style.
South Democrat project. Generation single on statement simply director law center.
Very near much hold several candidate. Else avoid sea.
Cell loss approach. Gun class discuss manager.
Out article responsibility who. International opportunity include candidate team most.', 7, 828.12, 271.86, 9, 34.839, False, 2025-03-08 23:41:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (69, 'SKU-85877694', 'Sports', 'Institution skin performance he opportunity sing. Head interesting common early look blood. Left able analysis arrive budget.
Although ago treatment society. Discover last everybody wall major interest amount. Might speech prove.
Challenge air rest wind. Less crime amount laugh. Approach Republican forward why spend.
Wide west man current hundred box. Agent north consider mother month.', 4, 616.06, 587.24, 4, 2.633, True, 2025-04-30 10:26:50);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (70, 'SKU-63753876', 'Garden Tools', 'Arm entire increase.
Whole phone agent attack bring. Open project buy edge after pretty one.
Attack resource serious teach piece especially able. Property remain first common eight. Maybe space father store start upon house paper.
Possible cup opportunity rate sport. Owner seek bill traditional western chance. Expert any look entire do company focus.
Say whom prove organization old. Yet land address represent.
Third summer what cause. Level middle star music commercial.', 17, 226.44, 233.60, 2, 20.724, True, 2024-11-01 03:10:11);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (71, 'SKU-49576939', 'Educational', 'Message mean year once too today base. While room Mr personal who until. Air star audience national human employee movement. Serious later they green.
Number key medical join activity. Article agent music industry. List behavior successful success herself be.
Before possible base citizen through purpose. Establish close prove nice measure leg sell official. Professor anyone amount great require else so. Interest great analysis tonight politics computer exist throw.', 16, 101.44, 770.99, 1, 48.229, False, 2024-08-06 07:06:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (72, 'SKU-20528501', 'Decor', 'Bill central wonder green set stay. Every national a whose whether single. Movement mouth maybe pass they.
House character would money own. Interesting perhaps as feel.
Only series right group. Policy clear star daughter imagine discussion little imagine.
Cost eat truth fly memory hundred.
Growth what seek many.
Pattern investment practice their. Event skin indicate suddenly like.
Significant camera else Mrs. Piece national what role term left necessary. Even kitchen including summer.', 6, 407.50, 935.09, 8, 23.925, False, 2025-01-19 19:10:30);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (73, 'SKU-41824362', 'Beauty', 'Note read term force open without. Book party reveal. Around reach local guess.
Goal audience bad. Dinner other sell new. Debate fire improve remember call method.
Head argue magazine any order prepare. Southern federal will economic another.
Radio ever total technology party issue. Anyone smile energy add so financial. Tend majority kitchen Mr ahead late.
Who court media part interesting drug. Election identify high capital plant side.', 25, 963.94, 321.84, 1, 45.406, False, 2025-01-15 01:47:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (74, 'SKU-64205049', 'Books', 'Husband shake party hope billion. Exactly work begin treat. Spring economy someone police year accept toward.
Board open word. Represent yard campaign themselves common other walk. Us today us event care responsibility.
Police interesting challenge book. Apply more director service.
Direction generation open history sell answer. Go standard collection work way company campaign. Reason discussion food education someone woman environmental.
Effort present expect level science thank.', 21, 574.55, 535.61, 1, 45.670, False, 2025-05-13 15:00:05);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (75, 'SKU-11390627', 'Toys', 'Top huge deal professor population question. Majority air test never. Rate standard today government actually myself.
Six while step effort resource create hit yes. Foot nation stop environment throw.
Thing activity tax tell skin. Method resource how listen. Method attack interesting writer everything.
Energy into stay decision movement gun. Little people late six.
Politics prepare travel. Drive other chair lead maybe produce.', 14, 882.35, 176.61, 1, 49.859, False, 2025-02-27 16:10:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (76, 'SKU-51182388', 'Tablets', 'Environmental toward story possible. Last miss draw society character both position near.
Turn church thing decide common term.
News deep certainly and bring continue compare.
As miss leave.
And ahead subject others. Try quality resource business natural stand country. Someone eye true dog need up.
Operation sense skill everybody. Political crime finally term open story so.
Cup significant admit.', 16, 187.12, 749.25, 5, 43.849, True, 2025-05-04 02:49:17);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (77, 'SKU-12119360', 'Electronics', 'Ability language food human stand. Especially peace among past happen no crime information.
Network help rise north if. Parent size month music newspaper mind.
Line yet produce magazine. Authority air sort investment guy such notice to. Really door against.
It reduce write lawyer. Miss next their herself few bad take set.
Various wait six guess member will. Leave lead relationship provide. Major his continue avoid.', 10, 568.39, 108.19, 6, 14.300, True, 2024-12-03 15:46:25);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (78, 'SKU-58400503', 'Fiction', 'Able official call thank. Store report adult same as human understand. Improve week least deep carry summer.
Me try particularly thought. Above become minute war stage. Claim energy laugh bed.
Hope value under some. According assume skill wall political send. Before off window particular.
Wonder prevent fire into. Season dinner stage. Apply notice current allow audience involve.
Above low town. Theory off fine represent. Dinner position something miss including.', 18, 524.79, 889.36, 3, 42.568, True, 2024-08-19 10:02:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (79, 'SKU-20633166', 'Audio', 'Professional idea range attention throughout degree think. Just model thing drop the character. Art television without itself seat language open.
Through us me natural whose. Son him wonder traditional why fear.
Answer free knowledge know everybody anyone growth. Friend bag which city north role act alone.
Blue management record room program outside. Between bar beyond single walk. Over rather central south.', 9, 193.62, 113.53, 3, 36.583, True, 2025-06-02 14:57:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (80, 'SKU-75952511', 'Fiction', 'Action teacher service record. Bad book Democrat. Trade get something rather.
Key three fund just analysis. Between kitchen course can organization anyone government. Purpose popular tree project stop answer work explain. Democratic fight return data today budget everyone call.
Into media recognize set ask.
Phone travel western wrong front. Pattern company nation get seek training rather future. Guess audience arrive.', 9, 718.87, 15.07, 6, 39.559, True, 2025-04-15 23:06:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (81, 'SKU-26017491', 'Shoes', 'Fill recognize worry technology after. Make help summer church foreign design. Stock authority defense here effort together.
Black Mr contain article cost. Reflect change smile film task attorney say.
Always time instead quality green accept share.
Trial member drug charge total because hotel. Some pattern according to free. Free theory none so myself follow not.
Commercial say side find. Another well drive provide think something.
Have minute back left leg agency other. Traditional boy song.', 22, 757.52, 176.32, 7, 41.367, False, 2025-06-02 21:52:52);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (82, 'SKU-16709159', 'Women''s Clothing', 'Travel reveal rather not its significant me. Movie forward nearly room thing. See real like region behind new and.
True long she record teach attack.
Wall meet old tonight sound everybody which financial. Price yet catch. Class approach necessary past Mr personal stuff.
Production choice edge everyone. Would pressure room under team security at.
Own cultural act call physical actually already. Without everybody research chance system. Response marriage sure camera.', 11, 87.65, 669.58, 3, 49.086, True, 2025-05-06 13:26:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (83, 'SKU-79842205', 'Men''s Clothing', 'Lead green total benefit Mr car. Raise prepare wrong bed.
Fear tend American war old what design. Enough success score.
Per hot character ball. Voice information add argue image.
Success traditional leave send through himself. Upon base mention hour gun field. Single situation feel already whole.
Range painting country different indicate. Few page cold. Can college care think brother.
Eight skill program try. Wait never fly pull big method.', 11, 935.88, 7.82, 7, 11.853, True, 2025-01-27 19:03:15);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (84, 'SKU-25052945', 'Magazines', 'Half door early we. Speak drive bad. Summer more if hear responsibility have.
Trouble nor environmental former law only. Return wall trouble friend current. Job nor yard establish hit.
Him southern issue town call computer experience. Movement traditional of. True fill beautiful game set other follow vote. High few land both two add thank.
Dream since open budget. His value experience young.
On easy today wait staff feeling first. Degree special laugh include price.', 9, 954.07, 302.64, 10, 0.671, False, 2024-11-18 20:34:15);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (85, 'SKU-42726287', 'Fiction', 'Guy wide evidence to item. Something employee such practice quickly any market.
Reality in game. Development know laugh officer.
Image crime about everything artist still. Record spring sport usually as until happen power. Already TV low.
Assume control leg suggest. Build ago feeling whose realize.
Several more physical beautiful year. Cup cup performance.
Million hospital trade agree. Offer piece machine early. Rest whom good throw.', 12, 693.07, 63.06, 2, 23.323, True, 2025-06-01 10:17:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (86, 'SKU-47518285', 'Toys', 'Dinner interview medical will. However traditional necessary learn memory home marriage.
Southern stop customer although add by how. Population weight wonder develop while question.
Relationship white manage soldier. Itself religious energy teacher single long food send. Certain woman who word. Center claim Republican admit.
Factor young get wrong teach not response professor. Team condition when if help start peace year.
Prevent too drug today so long. At positive mother even raise.', 13, 686.38, 923.17, 5, 34.545, False, 2024-10-29 19:30:20);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (87, 'SKU-76626319', 'Fiction', 'History finish everybody live gun edge. Son view process happy. Within environment back short pull form.
Now provide office. Or deep fly natural group continue.
Specific adult collection. Project author term many. Rock bed film wait.
Sell involve water idea mother. Image not model democratic close make low. Something world continue just.
Leave fund officer. Movement little name good subject very wait. Too recognize final boy begin show forget.', 10, 368.17, 221.63, 3, 23.961, False, 2024-12-15 08:44:43);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (88, 'SKU-65268732', 'Audio', 'Year none lay TV lose. Ability inside night. Fill name several market fear language.
Those become staff history girl. Either former age. Good recognize like also school.
Interview cost less bad third not group. Receive development day reason order rest conference.
Claim claim including deal. Doctor bad finish face modern. Subject shake particularly give example price easy.', 24, 988.84, 374.25, 9, 45.649, True, 2025-07-08 09:45:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (89, 'SKU-55018243', 'Magazines', 'Moment put price. Commercial different order matter campaign reveal rich.
Protect mouth side mission teach especially eat. Whose young set knowledge.
Boy long analysis force. Girl expert report include from song car.
Each amount everything. Summer high ask rich development area.
Today themselves blood single.
Four hour green religious hot former front. White new involve south two participant want.', 18, 802.18, 825.77, 4, 34.049, False, 2024-09-23 11:57:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (90, 'SKU-4494343', 'Accessories', 'Financial fall enter debate blue. Discussion late often mean really.
Story allow social write prepare represent today. Team high old anyone though president position. Just experience letter could also debate five.
Mr social hand another class. Participant exactly hospital Congress seem role senior.
Cut minute check soldier act. Care husband yard.
There discover detail effect life. Safe but too situation.', 3, 525.98, 528.64, 6, 3.997, False, 2024-10-07 01:12:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (91, 'SKU-31539529', 'Shoes', 'Establish truth society another music.
Water son special something. Before response whatever. Fall thing around sport.
Produce national role when story. Politics real fly employee black skill over. Understand anyone growth must.
Child quality pick fund the ask. First always what site. History serve example effort medical science.
Eat could of wait some between be. Budget leader message.
Work need southern sea anyone trouble. Lawyer anyone station fact.', 4, 62.70, 548.10, 9, 10.188, False, 2025-07-11 18:37:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (92, 'SKU-14682341', 'Kids'' Clothing', 'Common center man hold. Economic newspaper consider again tax. Certain heart heavy fly.
These him when training science ability much crime. Family kind toward adult maybe.
Meet oil former even again coach team. Raise she range author she finish small large. Perhaps tough however play decide.
Increase environmental laugh marriage five color. Note adult ball human my center. Card pressure of until character experience author under. Despite charge fish serious red I.', 5, 165.37, 854.62, 8, 5.900, False, 2024-09-12 07:52:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (93, 'SKU-29935290', 'Beauty', 'Analysis off surface. Region church standard base sure. Wear common baby see.
Represent Mrs thank myself. Matter husband throw billion old most energy. Around finally figure card student a some.
Up trouble marriage point lose story minute. Point example thank see simple budget.
Design probably born cell. Speak condition cover admit real animal. Particularly mother somebody both.', 23, 583.56, 91.85, 9, 22.330, False, 2025-05-18 03:55:30);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (94, 'SKU-22560859', 'Clothing', 'Accept view security much.
How their about place force conference each. Tonight near ability great ready understand successful.
Process north particularly arrive. Move it state series value tax. Such year deal the. Throw pull third data sport imagine section measure.
White tree seek should computer lawyer easy need. A avoid choice media.
Tonight response charge pull support. Glass cost say rock as.', 15, 132.81, 416.00, 10, 2.981, False, 2024-09-16 03:18:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (95, 'SKU-61826632', 'Audio', 'Good order often mouth. Must federal produce condition push. Reduce heavy receive state.
Shake particularly government stop catch large. Pattern or through class for. Evening itself PM shake scene though often part.
Physical central pay institution write. As just peace machine none. Site leader rather marriage next rate sure.
Every well cover part mean few. Left eye learn want gas human.', 22, 807.10, 723.55, 7, 12.797, False, 2024-10-26 18:48:46);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (96, 'SKU-73117', 'Electronics', 'Of couple program American lot project must. Peace say energy take yes. Girl worker door change whether small trip.
Defense quickly result.
Or thank others population. Treat wear hold. Newspaper should court just.
It notice me look return. President most class. All piece daughter.
Answer even fast wear. Capital other analysis low professor. Next upon stand hear feeling although.
Bring travel particularly job. Carry usually should contain talk by account.', 24, 218.68, 73.96, 7, 17.292, False, 2024-10-27 07:50:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (97, 'SKU-80635631', 'Books', 'Color summer stand move fine major. Wide explain rock design. Reduce technology other about.
Campaign continue before than upon single. Type policy plan leg church.
Politics rule pay new Republican fly foot. Once figure race get.
Image within foreign happy. Large area trouble more. Guy out election.
Especially discover hand Democrat sign. Just more sea run born. Budget oil reduce woman least employee suggest.', 18, 994.12, 934.64, 2, 49.308, False, 2025-02-02 08:11:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (98, 'SKU-26346840', 'Men''s Clothing', 'Still itself firm artist consider.
Impact story defense force difficult. Anyone mention tell green rate could evidence. Market same kind her class speak.
Would difference sport carry. Offer thousand pick involve will game participant offer. Ready born mother. Future direction admit town strategy raise future.
Music important miss toward. Practice hope save method.
People voice style past leader. Just night theory statement three forget. Give mind watch score successful anything century.', 2, 287.80, 180.80, 3, 38.315, True, 2025-06-06 10:58:00);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (99, 'SKU-27663707', 'Comics', 'Set civil yet word bit consider design. Decide me sell. Box bank early worry man much every.
Activity start scene pay true whom result. Suffer street knowledge officer have challenge technology under. Debate statement health physical prevent season Mrs again.
Shoulder protect crime. After season business drop once action. Call of listen care term glass during.
Off real foreign. Something talk response amount foreign these federal. Deal attorney gas recent skin many here.', 21, 963.81, 375.08, 7, 22.482, True, 2025-06-16 09:38:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (100, 'SKU-50408631', 'Decor', 'Maintain control get theory big face hotel quickly. Process stuff treat.
Consider agreement citizen organization you practice important. Trial far miss help effort attention. Baby throw perhaps recent where follow.
Movement stand try important enter wish. Also protect natural career.
Enough main decade. Value meeting bill plant.
Break sense discover first deep again in. Industry I receive.', 13, 376.27, 683.04, 9, 6.736, False, 2024-09-17 07:37:58);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (101, 'SKU-14181221', 'Bathroom', 'Simply she along figure decade. Service top medical day like prepare grow. Develop doctor identify set last stop behind.
Actually tree walk give mention PM industry age.
How give skin wide. Attack suggest television discussion be. Right green left.
Serious at argue real ready.
North city he sit. Poor arrive lot pattern better plant certain.
Weight agreement room newspaper character hope eight. Imagine contain health yeah success soldier control.
Strategy really pull common between.', 12, 119.51, 992.84, 7, 26.489, True, 2025-01-07 17:31:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (102, 'SKU-72974361', 'Comics', 'Act let painting. Art manager carry. Whole ago left past become sell alone. Commercial behavior daughter spend not sea line.
Many control agent statement first two. Sea society your book cold.
Strong lawyer fill imagine work certain difficult. Fall skill total contain certain.
Century Congress treat. Sense center run view room. Even score land successful third heart against purpose.
Good behind type like bad letter stand result. Wife quality establish. Still grow music born already black.', 8, 834.98, 756.42, 5, 23.204, False, 2025-04-20 17:18:42);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (103, 'SKU-56546065', 'Comics', 'Less yourself traditional matter especially. Else memory discuss start newspaper become north.
Make people note. Join analysis idea say. Value shoulder wall cut part room campaign.
Woman everything especially join last week. Citizen difference whole improve ever could research.
At coach sea man.
Grow forget these. Ability again nature heavy soldier.
Dream born above might occur sing yourself. Edge image able often. His send physical star.', 18, 424.70, 379.89, 4, 12.451, False, 2025-01-13 22:31:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (104, 'SKU-64428388', 'Laptops', 'Each anything TV staff win middle. Eat budget benefit strong well.
Model be begin page. Reason form center of source change.
Player source professor attention data.
Include air focus want parent. Exist three event identify kid.
Around case thing return.
Travel read charge case development land two. Why chance three cell most.
Market read toward life. Pm cover find week develop yet. Across beautiful people.
Necessary forward near rather. Pick skill window generation. Expert term huge.', 5, 276.37, 937.46, 2, 1.708, True, 2024-08-22 16:07:57);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (105, 'SKU-11442470', 'Non-Fiction', 'Drug century beautiful bed these traditional customer. Nothing wrong phone attention.
Ahead toward water resource. Marriage investment seem.
Fine rise wife figure concern. Without industry despite plant.
Blood because door. Material sea personal day rule man. Else glass which bar.
College vote series see call learn well. Laugh about hot industry speak various. Well task everybody baby unit these.', 14, 615.30, 936.29, 1, 12.109, True, 2024-11-29 02:31:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (106, 'SKU-97449882', 'Books', 'Natural water character from PM such. Scene green ground offer common wide process everybody. Poor because buy provide partner.
Nearly most less able protect do different. Smile matter tell south right month everyone soon.
Year if term. Girl better beyond. Consider claim there.
Prevent everything soon cost tell. Remain anything particularly week.
Statement dream central. His would dark artist recognize bit land. Performance treatment anyone become everybody voice decide try.', 4, 594.34, 446.99, 1, 12.312, False, 2024-08-21 13:32:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (107, 'SKU-96872791', 'Clothing', 'Better possible suddenly player start. Test TV pick baby when future. Morning relationship against two newspaper put.
Seat likely single out argue dinner born. Black agree real book past wish. Candidate dark other serve.
Loss simple movement magazine study. Language information tell. Consider expert address.
Six letter wife all college either. Create should degree house control. Hospital also year own.
Good lay huge line home kind radio. Join real early sure. Recent vote wall become area break.', 13, 439.52, 540.21, 1, 7.093, False, 2024-09-23 23:20:47);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (108, 'SKU-38729652', 'Food & Beverage', 'Me detail act tree school. Speak avoid administration teach another big treatment help. Shake research writer recognize identify some.
Television discussion nearly behavior for star they everybody. Inside shoulder choice measure space skin talk.
Line necessary fly share ten carry. Town traditional forget better.
Head none media game employee heavy voice animal. Left dinner himself child skill itself scene yard.
Significant life already ask big leave. Step less gun south.', 8, 815.96, 731.78, 6, 28.916, False, 2024-10-07 21:04:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (109, 'SKU-44604683', 'Magazines', 'Rate idea challenge late never street. Large investment carry.
Raise century watch teacher relationship wall. Risk whom husband individual catch. By throw issue mean little appear time really.
Truth model hotel quickly computer really sister. Employee get agent modern strong.
Customer individual base toward other last week. Fire radio scene.
Around list other leg represent general city. Only television drop sit. Chair Congress decide I study.', 22, 818.56, 237.66, 3, 49.286, False, 2024-12-24 05:39:43);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (110, 'SKU-15303511', 'Women''s Clothing', 'Student identify network allow compare. Structure western account once.
Ahead conference including which. Some add you three continue however many.
Institution agent author let. Tv south ball.
Thought always garden action allow on decade. Strong contain true heavy difference both.
None site item drop. Accept develop none scientist series foot article. Past partner would foot recognize despite.', 8, 414.14, 275.88, 9, 47.431, True, 2025-06-17 19:40:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (111, 'SKU-23037865', 'Garden Tools', 'Need field with open. Perhaps phone health laugh a. Itself staff industry manager guy include that.
Nation professor two. Where such organization coach sign tough since.
People evidence my trial once. Together give court deal.
Each attack child hear.
Table arrive peace role writer exist. Difficult if mean. Speak expect situation perhaps sense early themselves.
Hour clear interview account Mr. Nor science yourself discover call whole.', 24, 911.66, 626.36, 7, 27.837, False, 2025-01-04 16:59:27);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (112, 'SKU-26586910', 'Clothing', 'Least onto everyone assume address consider simple. Political not top game worry.
Car how away director loss discussion husband want. List character table picture human.
Today center agent per. Large short ago number. Process these total firm.
Article coach black government discover. Great fish even rest cause old.
Down subject military kid true. Point end painting camera realize edge capital.
Nation remain effect something focus use social. Congress until account sign low among manage him.', 12, 941.64, 671.66, 9, 16.005, True, 2025-05-14 07:47:19);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (113, 'SKU-70771894', 'Gaming', 'Stop must win fly join. Career small adult meet huge by once. Gun under television point.
Bag one collection city contain go. Mouth good somebody value. Collection third feel common in open.
Position before watch society. Two beautiful now company activity.
Reduce individual color really always improve a truth.
While guess create. Local expect always response. Avoid say base detail have customer people care.', 14, 150.07, 377.08, 9, 23.729, True, 2025-02-01 20:51:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (114, 'SKU-58509056', 'Bathroom', 'Example remember require government address for. Community even bed step probably tax pull.
Skill boy poor society else. Whole federal voice resource.
Everybody stage break see least less. Model live inside truth all teach. So page conference window standard.
List teach beyond nearly. Your structure manager. North common recently American collection night knowledge entire.
Shoulder collection environmental into. Someone may home eight now young.', 8, 301.43, 707.86, 8, 45.746, True, 2024-08-03 00:47:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (115, 'SKU-79942779', 'Kids'' Clothing', 'May front those loss want. Before risk doctor sister. Administration something ok detail move energy interview fight.
Family lay what mission. Defense anything road bank sell. There eight increase level quickly hold.
Network speak who attack process think. Mind staff second number.
Laugh under cold successful. Since final American.
His face door in think almost tonight. Relationship know trip option early. How popular program.
Likely social toward nature career same.', 14, 967.81, 557.72, 3, 19.482, True, 2024-11-28 02:40:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (116, 'SKU-91232797', 'Health', 'Really than mean loss hundred score fire. Summer such PM number catch brother.
Energy task institution record. Nation husband rich ahead. Day stuff several I clear us.
Court special ok short meeting past pull.
Us make no industry follow third daughter. Less leader trial accept institution. Particularly commercial onto citizen deal.
Reach professor win beautiful side whatever few. Realize both grow not without last yes out. Pay standard keep ability. You most when even no.', 7, 330.93, 79.99, 8, 42.372, False, 2024-10-26 22:07:00);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (117, 'SKU-90972887', 'Books', 'Third month tell serve TV bill. Think ok reveal center sure.
Forget current large another. Approach out choose piece amount they data. Pick all political term teacher lawyer I.
Over increase community thank. Strategy successful for water produce. Leader might process.
Contain positive place become industry able view. Rest this his body. Image car newspaper most subject drive build.
Yes instead pull think. Especially for organization picture contain.', 18, 724.85, 191.29, 5, 18.921, True, 2025-01-07 04:01:19);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (118, 'SKU-80083793', 'Accessories', 'Bed unit whatever learn eat consumer travel now.
Economic heavy set a. Drug five such through final. Great recognize interesting may bad mouth.
Single everything administration during hundred reduce. National budget them now your eat hard. In yourself whether discuss although idea.
Simple wife imagine one can ok note machine. Care anything either painting. Continue which nor can himself huge.', 20, 40.51, 73.71, 10, 36.243, False, 2025-01-28 23:33:33);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (119, 'SKU-95310097', 'Kids'' Clothing', 'Particularly head sit activity building effort common. Way space time spend believe customer month. Wish outside choice call act.
Face anyone without recognize.
Style right want what. Scientist product table that room. Audience feel admit might offer focus top.
Car option music popular strategy himself civil. Father activity perform remember. Area consumer front discussion.
Year into wall bill wall next per. Trip nothing with since. Power tax I.
Be probably early. Large impact beyond.', 7, 479.91, 869.60, 6, 15.229, False, 2025-04-15 06:55:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (120, 'SKU-83036858', 'Decor', 'Best appear majority cultural college many. Artist industry serious seven conference and. Street season on reveal opportunity middle.
Least couple rule special system. Every large nearly a even.
Know when indeed. Simple firm assume why. Reality like focus.
Skill picture within read. Bed reason which coach Mrs girl. Goal cover eight painting available. Meeting general name bad say believe.
Even song hotel hand own. Two another man list. Expect onto throughout.
Five find much world yes.', 1, 212.59, 190.83, 2, 37.369, False, 2025-03-05 04:51:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (121, 'SKU-53598533', 'Magazines', 'Will season process move actually hot church recently. Wife him reality remember.
Reveal garden individual customer usually. World feel sure me medical apply shoulder it.
Rest painting lot why others American quickly.
Record begin stuff state pick without tend bad. Race treat specific her benefit.
Network night garden song drive. Born prevent allow yes. Chair finish over like.
Local evening represent fast risk when arm.', 16, 914.52, 695.92, 4, 19.892, False, 2024-10-10 14:43:22);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (122, 'SKU-33312461', 'Automotive', 'Heavy able discussion add see available movement. Can main new. Accept trade might any up appear door.
Draw stop he can most political. Entire account nation building teacher only. Brother close south down agreement half age energy.
Should least he level our. Tax off station wide among.
Involve card whom give spring manage far. Election event picture weight analysis experience. While example experience forget message buy administration. Building nature hope picture morning exist stuff.', 18, 322.29, 283.77, 8, 26.729, False, 2025-06-24 03:32:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (123, 'SKU-18728710', 'Laptops', 'Institution language fast tell child instead TV. Capital government yes.
Half audience western race attack discover rise. Institution speak firm approach. Key artist can eight avoid early for.
Enter report why rule half best speech. On floor least of save serve usually. Mother itself season feel responsibility oil involve.
Network crime focus parent. Physical nice how western hear. Any control drug second long listen room.', 10, 262.30, 513.30, 8, 23.354, True, 2025-07-05 02:34:22);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (124, 'SKU-75251989', 'Furniture', 'Drive clearly house sound who heavy. Present election keep truth perform remember difference movement.
Another draw consumer offer. Read a interest country seven. Might fall defense father.
Opportunity change part son low star television foreign. Real camera home trip kind.
Ready performance cut where buy about strategy. World degree choice similar it. Right character campaign last level data away though.', 24, 470.02, 839.88, 4, 18.598, False, 2024-11-25 07:51:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (125, 'SKU-97700383', 'Gaming', 'Today establish push than.
Media into inside he unit success. Store add always religious course meet. Plant soldier want third somebody watch.
Off environment organization population decade. Understand wonder recognize number machine off must.
Smile election trial media alone science thousand sport. Term others song.
Statement simple job describe. Seat wish either herself.
Church nature region they. Produce travel forget explain.', 2, 562.96, 222.05, 3, 0.909, False, 2025-05-06 12:21:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (126, 'SKU-61887143', 'Kids'' Clothing', 'Ask message may center whole day moment. Power around price win face hold anyone. Would customer rich offer.
Fill section offer movie thank even. Send foot into. Perhaps note someone cover question drop.
Teach know cut sound anything myself off cell.
Husband account industry green five last. Image everyone material unit water follow seem.
Goal yard common like ever according hit. Front skin increase most car raise group. Him effort blood compare either few.', 19, 579.56, 418.16, 3, 9.890, False, 2024-08-09 12:08:26);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (127, 'SKU-32903530', 'Automotive', 'Animal performance special environmental trouble. Poor article and really rule music save. Air participant their section defense.
On item at. Little machine suddenly start office main subject from. New body guy participant. Actually fish amount daughter send help reality.
Wind add focus policy well of quality. Once physical nature cell work ability.', 13, 570.21, 246.48, 9, 32.765, True, 2025-04-13 16:03:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (128, 'SKU-41441410', 'Non-Fiction', 'Tonight scene year rather return cut may. Stuff floor political them.
Black inside each short collection. All poor reveal heavy performance evidence. Information lose up decide support kitchen record.
Consider opportunity price politics race he. Type sometimes bed must change single though. Start none increase nature structure value.
Card right detail listen late. Watch agree charge commercial likely still argue.', 11, 258.07, 821.76, 8, 23.095, True, 2025-06-25 04:06:37);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (129, 'SKU-60724532', 'Comics', 'Method good ask management around ok hard. Several phone cold step decision enjoy memory in.
Technology where rate. Bad down human board boy place. Agreement sure scene natural southern between up positive.
Poor suggest six better short spring ago. According I resource sure other their another. Car loss chair never hold parent discuss ever.
Product parent law animal research analysis. Foreign memory including million role different window. Great land song kind science she.', 12, 170.09, 720.59, 8, 9.284, False, 2025-07-08 10:42:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (130, 'SKU-99207127', 'Garden Tools', 'Event state enjoy find word Mr bit. Find final low anything.
View within soldier surface. Hundred wrong box physical hour.
Avoid also police there late land apply think. Police few sing environment international. Enjoy with off fall trip.
Rise interview fear against it visit. Floor despite material product than great war hand.
Travel protect production do meeting which similar decade. Carry stop former.
Politics you dinner company bed. Attention get school Mr on someone. Water travel feel.', 18, 990.32, 957.27, 9, 1.788, False, 2025-03-04 02:06:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (131, 'SKU-9637542', 'Bathroom', 'Direction shake study property. Recognize around opportunity stage data main.
Ago you option rest by. Eye PM drop cut various speech. Which play wide see offer position.
Bring three indeed laugh. Outside help indeed itself. Ability young second trip.
Specific TV care support. Card recognize detail party.
Authority write rise. Network through major pay administration listen. Pass force player everybody idea ever agree.
Early teach artist fight house. Its film than heavy apply near.', 3, 945.23, 668.54, 1, 20.678, True, 2024-11-25 18:17:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (132, 'SKU-81585045', 'Kitchen', 'Describe teach society.
Able condition soon gas rock without. Single understand eight near loss. Mouth movie of feel.
At understand every rule receive. Rather factor stop chance behavior end.
Moment level station degree care read face. Focus during many itself believe create recognize source. Appear beyond recent lose during find old. Begin assume director loss include piece.
Sometimes back lay animal provide piece floor.
Former law apply politics. Central into official.', 21, 232.20, 707.46, 1, 11.014, False, 2025-07-07 07:42:55);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (133, 'SKU-44995235', 'Audio', 'Push trip catch. Scientist benefit small agree important. Billion away floor.
Center believe teacher interesting economic support mind. Career carry also yard. Than onto contain compare head. Pretty believe professional pass.
Box debate move decide.
Court politics hair military. Someone citizen run effect. Quickly four describe control hundred significant.
Kind soldier community on involve cover community approach. Week easy seek PM list toward start everybody.', 12, 61.39, 638.08, 10, 45.646, False, 2024-08-25 07:28:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (134, 'SKU-83159763', 'Non-Fiction', 'Feel entire situation hard eat support. City there since we under hour. Project full night recognize record imagine.
Thousand security child dark treat sense hold. Character billion little church leader population value week. Natural different even vote expert nature matter investment.
Include big room. Fast like police pattern. Skin baby benefit team purpose matter big.
Reason because each market decade. Here likely coach store. Wall event party.', 16, 16.72, 532.67, 7, 0.691, True, 2024-12-30 16:51:55);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (135, 'SKU-94292151', 'Women''s Clothing', 'Seek day staff our least security. Team open tonight activity house of measure professor.
Politics reflect himself factor. Because improve writer agent radio nearly despite.
Book bit hope college size number box simply. Nothing evening one seven ball.
Evening evening live program street. Whatever event some example stay.
Become artist author its over. Available economy name. Hundred wish official report.
Answer find together. Throw although morning store.', 24, 275.46, 977.49, 1, 25.161, False, 2024-09-08 03:12:03);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (136, 'SKU-65184646', 'Educational', 'Day myself arrive food. Between reduce beat many data career relate. Radio unit stage you field less test claim. New pretty eye budget subject least place.
Training value avoid upon. Wide live member make far. Could author never who also PM.
Wife price her site your college political budget. Theory away down turn design.
Others item product home image education.
Cold follow serious market find avoid. Plan executive result assume. On others party minute trip grow hospital.', 22, 431.14, 939.76, 3, 5.440, True, 2025-07-12 01:44:39);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (137, 'SKU-19548080', 'Home & Garden', 'Point beat choose identify set gun happen. Him account against amount family.
Stuff above stand meeting. Technology end skin mention sing bill.
Why wonder in.
Arrive evening will service magazine movie account imagine. May born go society claim. Central challenge company choice actually.
Force choose cover yourself opportunity father ability. Although seem environmental painting.
Health site relate very get. Step watch fire.', 17, 149.75, 192.74, 9, 12.696, True, 2025-07-21 04:58:26);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (138, 'SKU-95602621', 'Laptops', 'Feeling party the call several. Upon enjoy light improve. Explain this can already be member new.
Against develop general wonder nice. Purpose dinner next. Property best station per. Economy truth dream result other add.
Follow general manage head occur recently again. Cost thus a industry who. Point ready grow check part myself address.
Home inside drive. Series he throw bar five know behavior.
Professional attorney onto necessary cause detail. Mention create reveal.', 9, 795.13, 79.94, 7, 23.004, True, 2025-05-08 11:05:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (139, 'SKU-44425264', 'Automotive', 'Walk huge blue movement firm. Suffer once agreement company material. Address everyone hard article you defense.
Some put fact consider develop bar policy TV. Moment difficult evidence treatment.
Itself contain think pay before citizen magazine week. Catch capital few imagine must shoulder toward grow.
Compare image page little wrong above determine call. Seem will building discover church and.', 23, 226.63, 684.35, 2, 32.721, False, 2024-12-12 10:42:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (140, 'SKU-57752132', 'Bathroom', 'Certainly success heavy responsibility exactly man. Science government outside able last young speech.
A soldier general sound describe. Bar his physical let site.
Former face safe study know. Past war good question.
Prove wind into inside. Future general probably possible service at.
Civil beautiful record fly natural image avoid.
Choose early push hospital. Natural until agency pick local into friend career. Range but green choice than. Stand might expect mention increase treatment.', 21, 759.82, 94.41, 7, 18.921, False, 2025-07-20 13:06:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (141, 'SKU-32971677', 'Men''s Clothing', 'North recent them reflect available century join. Probably maybe herself partner camera long who require. Make network soon market.
Author world time try cause behind single. Sport sound clear. Hotel contain knowledge soldier detail thought.
Maintain year firm generation. Major strong pull finish seem.
Within employee kid fall international clearly sport. Explain happen build fill personal fire when. Can nothing force move free body stand approach. She seek then represent conference war.', 2, 637.10, 703.14, 2, 25.043, False, 2025-07-30 20:54:56);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (142, 'SKU-93849700', 'Gaming', 'Treat win rich less theory.
Tell fact pretty learn. Discover particularly care fall new. Similar cover population thing.
Recognize especially ask two major she knowledge. Culture picture provide support six space.
Above attack catch soldier charge. Through result military. Truth call stage significant thank data year.
Support put herself water meeting voice. Painting material science beat deal across friend.
True three theory outside agency world true evidence. Box could end.', 21, 784.58, 566.29, 2, 44.750, False, 2025-04-08 05:20:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (143, 'SKU-8054992', 'Decor', 'Describe model meeting. Experience point article. Evening ask if throw.
Reach street course plant. Ever position local leader. Media culture person activity two might.
Example body subject late energy before. Also thousand so price if paper really position. Low bill behavior hand until.
Within both notice like story just often. Dark current including live among fly agreement. Debate couple ground much open instead keep.
Hard half dream easy prevent side meeting. City hundred center life since.', 2, 230.53, 901.36, 10, 23.827, False, 2025-03-07 08:03:43);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (144, 'SKU-86885711', 'Clothing', 'First point specific report clearly. Themselves have feel blood.
Sound level couple. Movement nor line.
She difference ten suddenly wear soldier light.
These may cell campaign. Present TV cup sister article kind bar.
Still respond everything. Far face describe question appear.
World behind people up Republican interview build. Old listen heavy report its sign I lay. American participant race model doctor.
Administration past happen claim station. War worry here Republican cultural.', 3, 684.74, 281.09, 9, 28.219, False, 2024-08-05 05:55:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (145, 'SKU-4124511', 'Clothing', 'Care give occur. Prove suddenly travel our tell. Determine eye matter debate man.
Cost exist idea now stand his wife represent. World hold exist story speech age.
Wall wear realize stage. Interest chair million financial much enough.
Write marriage campaign able. Ready same price. National professional beat. So floor operation nice full decade.
Theory husband prepare role these receive cup. Floor inside pretty describe our.
Become around reveal. Appear star open at kitchen box about wait.', 6, 928.83, 315.17, 4, 29.393, False, 2024-10-26 11:13:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (146, 'SKU-85007767', 'Magazines', 'Interesting drug individual color trouble agent. Cell case play mind. Table tend occur sister thus wonder.
The treat detail. Already give nature deep. Across party market dark language.
Without behind once by final. Paper listen impact tell positive serious. If magazine look term.
Long thank by most special describe unit. Name town project agency rock however. Least husband option contain.', 23, 821.07, 928.94, 5, 8.206, True, 2024-12-12 08:54:38);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (147, 'SKU-83548775', 'Automotive', 'Let its window structure herself agent stuff. Hard score agency ahead authority report various. Significant body water hold.
Old occur well cause whatever television test. Soon move kid possible success final. Always their guess analysis responsibility contain.
Region Congress way night threat glass leg anyone. Politics similar operation adult big.
Plant as medical structure already every. Senior age product over chance Congress dinner.', 19, 834.81, 389.76, 9, 16.653, True, 2024-11-10 14:08:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (148, 'SKU-94187158', 'Magazines', 'Guy light society play yes recently force. Southern several figure watch. Happen impact since many anyone herself tough smile.
Education head effort right exactly. To window production industry until method. Media skill no task product.
War picture take story democratic without stop. Finish child team specific list modern above. Too fact city this impact sound night.
During wish issue others front. All agency right figure son guess result.', 24, 140.81, 988.48, 2, 25.090, True, 2024-08-26 10:06:35);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (149, 'SKU-56600975', 'Laptops', 'Next go great put ready player. Yeah age continue none find.
Those cause less enter raise. Station seek per strategy former. Something right beyond central.
Ahead year cold group those stage chance. Subject herself consumer property book anything. Many more network quality give garden.
Place issue American page training. Once food bad program.
Stock fine range read recognize under. Career cost suddenly indeed customer kind.', 2, 98.59, 232.91, 2, 17.096, False, 2025-01-20 11:17:19);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (150, 'SKU-52647572', 'Magazines', 'Operation usually interest. Base strategy drive so dog.
From available seat wait financial allow form past. Music truth by quality rich key quality beyond. Weight democratic sit still. Turn most although maybe sure bed factor.
Certainly part drug fear. Teacher certain compare.
East car gun he. Level paper ask responsibility fall agency.
Else time miss religious positive eat third head. Though rate talk professor.', 20, 954.89, 397.30, 6, 1.578, False, 2025-05-30 22:27:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (151, 'SKU-64967606', 'Health', 'Grow north radio. A poor get organization peace rock health.
Effect fish action write. Capital position score.
Night never alone defense vote. They color first hundred seven another. Evening painting responsibility.
Impact ready quickly father attention. Drive interest measure and.
Professor land author the finish during exactly. Beyond financial chance better.', 15, 491.11, 356.45, 7, 21.649, False, 2025-05-19 16:50:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (152, 'SKU-68488718', 'Non-Fiction', 'Possible into contain amount government. Either response sister whom. Lead its especially. The agree pressure mouth parent bit.
According he share think once ball enter. Gun various inside line pattern.
Hope boy control into back keep. Read put matter seek. Drive great blood score share high.
Despite agent guy debate better name system. Section statement another role design pretty response. Project which few skin though.
Interest road a week book south indicate. Range company provide hear.', 19, 661.00, 86.61, 10, 14.839, False, 2024-12-30 06:36:03);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (153, 'SKU-79611948', 'Automotive', 'Until describe necessary single discuss agreement must. Raise turn direction rock real bad general. Section certain western write.
Product cold various himself. Development ask traditional anyone sea rate often bank. Color message exactly buy court beautiful box. Significant watch present summer lose quality moment rock.
Strategy local expect pass person. Firm upon care make. Evidence table so write.', 23, 74.43, 268.70, 7, 35.613, True, 2025-05-18 01:19:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (154, 'SKU-55622207', 'Fiction', 'Others participant design trial medical become. Moment ready operation oil one.
Within coach another shake poor actually baby. Girl somebody receive boy develop worker create. Sort drug like technology.
Official senior animal ready strong. Live clear ground fast middle. Me game inside whose test quite.
Serve buy loss everything run page child. Since throughout black speak attorney outside. Follow thing at school. Story test today toward blood.', 5, 739.91, 317.36, 2, 4.667, True, 2024-09-07 05:16:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (155, 'SKU-42137826', 'Food & Beverage', 'Simply owner across sign like. Miss say simple perform practice investment. Gun small Mrs career everyone.
World particularly term reflect leave player throughout.
Industry meet at deal. Like various laugh long carry long difficult family. Relationship Congress car.
Same war behind pattern. Specific article purpose early safe.
Final add through between so face. Fast will their establish. Church evidence speak.', 15, 360.55, 270.49, 3, 4.456, True, 2025-03-30 22:57:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (156, 'SKU-72363716', 'Gaming', 'Today level floor store. Feel foot behavior plant. Meet station history away. Agree current himself pattern.
Order compare plant company lose represent item. Outside simple now do Mr behavior.
Strong person my senior. Quality structure soldier situation figure exactly piece chance.
Interesting concern seat establish course south.
Page weight either line bill whatever money. Total effort also itself space speech. Expect road computer want.', 15, 557.42, 512.92, 2, 1.410, False, 2025-07-03 23:05:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (171, 'SKU-82783158', 'Non-Fiction', 'Edge here skin sport threat. Not window remain quite able partner. Course join they follow. Out bed media drug.
Size technology enter.
From mother sister future blood which place. Situation eight gun white toward morning according. Window improve year wife half.
News wife interest morning whether name agree.
Director operation candidate. Eat avoid lose top.
Why tough nice who two week simply product. Specific not since city those market step.', 5, 715.51, 789.28, 2, 22.508, False, 2024-08-05 00:35:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (157, 'SKU-1108200', 'Laptops', 'Interview toward them instead force follow benefit. If and leader sort mission above seven.
Ever nearly wear defense ever expect. Population project might its last much often lead. Red leader table politics the term. Once be end key bank ago.
End week respond war bill hot stop. It for present baby road institution.
His product end thought.
Exist debate whole particular policy. Offer foreign third yeah everything service.
Sit impact religious social director gas.
Station see enough concern.', 18, 93.97, 598.44, 6, 43.200, True, 2025-07-07 10:11:28);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (158, 'SKU-40380007', 'Electronics', 'Pick set economic positive. Each security teacher test provide cultural mention. Affect style against bag shake.
Official over base southern possible ability family. Teacher challenge than remain least model serve. Through hold increase.
Section democratic fight example pick.
Meet our section responsibility discussion Mr. Cultural he quickly become.
Third study though feeling term leave though.
Three hold wall know finish American. Top never though major many situation whom teach.', 10, 414.39, 779.38, 9, 45.270, True, 2024-09-02 01:19:14);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (159, 'SKU-41355888', 'Automotive', 'Go fear away senior short prepare. Arrive open small poor another. School someone head ground media. Seat reveal gas moment when.
Half garden Congress customer quality walk. Worker piece trip provide add when. Letter talk number bad art.
Once send gun instead bad. Maybe option human fire ball natural raise five.
Skin everybody interview find fill large type. Poor possible memory protect exactly left on.', 19, 521.58, 685.62, 3, 7.028, True, 2025-06-29 23:25:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (160, 'SKU-2328554', 'Food & Beverage', 'Study quite perhaps institution trip. Effect great describe because. Heavy final film test degree opportunity.
Law scientist fund end federal. Still able force energy billion.
Situation lose difficult ground bank. Including understand ten look believe bed.
Baby purpose across green hear environment. Significant movement bad decide perform money.
Point really major own gas performance. Around officer field though soldier away color your. Form space style win book leave.', 9, 493.63, 64.20, 7, 13.870, False, 2025-03-26 00:17:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (161, 'SKU-49657261', 'Food & Beverage', 'Season drug several appear onto type community. Fire line cover before beautiful rich because. Base third ground cultural approach.
Development couple speak father last mouth. Throw pattern thousand imagine.
Field should floor image style it see. For though build next wind. Opportunity center voice tax our game area fill. Various true sound age.
Word herself past admit time thousand. Player civil economic son but movie individual.', 16, 782.88, 361.76, 4, 36.073, True, 2024-09-24 19:50:25);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (162, 'SKU-88858674', 'Men''s Clothing', 'Can car physical any cut certainly another. Tree environment fund management can source news. Certain glass far control.
Quality memory understand politics religious challenge.
Human south analysis need community very consider. Industry grow feel. Enjoy west human woman whom among often. That play will once form.
Daughter behind home phone great. Determine next most unit. Road herself international work with perhaps.
Deal probably appear positive. Successful age because best.', 20, 617.05, 458.40, 3, 15.302, False, 2025-03-17 16:48:37);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (163, 'SKU-43305637', 'Tablets', 'Collection responsibility face available represent business least. Room whatever do key night open third.
Democrat argue north rock call role management. Eight member military spring more show strong. Here produce or coach similar vote.
Their city town response. Set book despite. Health among together method interview.
Machine important manager adult we everything. Despite wind safe off store little chair.
Player ball local today raise remember. Pick type record major Mr leader everybody whom.', 11, 841.76, 380.51, 6, 22.067, True, 2024-10-27 18:51:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (164, 'SKU-35999989', 'Gaming', 'Green five should single job thought. Idea morning interview very account speak not deal. Stand article book six student beat say. Little police common exactly call exactly must.
Sign outside look improve any. Mind effect pressure any bar plant media almost.
Cultural feel above stuff four.
Security hear thing human would magazine. For evening thing generation one throughout.
Three machine environment security wrong plan case carry.', 21, 974.24, 136.99, 6, 30.200, False, 2024-09-24 16:10:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (165, 'SKU-11991120', 'Educational', 'Consumer employee wall he local mention. Security able night since against.
Bank sit none now beyond measure. Low have check quality everyone benefit fill. Fund public investment every.
Mind pull each sister. Production live key its here five. Loss gun field.
Possible remain police fill worker. Mr price big teacher song company. Rise stop enter partner. Main water really.
Generation growth less by. Professional body wear.', 7, 479.53, 178.46, 7, 48.439, False, 2024-12-10 13:44:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (166, 'SKU-53860348', 'Food & Beverage', 'Development establish whom plant. Believe move then hear degree.
Down certain happen health. Adult simple seek size student magazine our. Gun maybe president I choice today most.
Policy since improve draw score pretty while few. Feel let edge.
Plant benefit role manage operation result. Wind buy glass floor future. Million describe voice. Research I but agent part home.
Least past all suffer.
See vote least so especially almost. It our want fine quite huge region.', 24, 695.26, 491.51, 10, 39.121, False, 2025-06-06 18:13:25);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (167, 'SKU-47787663', 'Smartphones', 'Imagine major lawyer car Mrs establish be degree. Star send partner avoid couple page. Close play wish dinner if.
Look sign nothing kid star artist. Minute against region take through.
Trial purpose direction.
Join half sport hope agent company sure consider. Down role special watch remain son. Though tell mission investment.
Because call campaign cultural. Away phone coach term. Bar board majority politics nothing without. Special tend hour serve five white.', 13, 281.02, 786.07, 6, 5.783, False, 2024-11-26 15:30:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (168, 'SKU-13383788', 'Shoes', 'Technology voice employee provide coach. End mission cup food. Tonight born kitchen must.
Crime meet there. Turn light lot run action instead. Itself will down let certain page able.
Ready assume indeed when material among nation. House any feel may sport develop difficult. Hit father foreign hundred.
Level body party husband follow town. Participant after six economic something. Whole rest seek. Director candidate sport.
Late apply need scene health off could year. Often let action everyone.', 7, 592.63, 546.08, 9, 1.443, False, 2024-08-11 12:38:45);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (169, 'SKU-73873832', 'Comics', 'Happen everybody action ten up discussion significant. Nation series still court stuff police. Impact large those.
Lose full effect off. Business then same fight traditional share. Treat each beautiful form.
Religious not activity determine space television law manage. Bank magazine agree allow improve later arm. Field can travel recognize above behavior hot.
Set piece opportunity decade large. Else series law strategy leader tend itself. Act evidence financial walk.', 15, 943.02, 210.44, 5, 41.581, True, 2025-03-17 14:48:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (170, 'SKU-40731130', 'Books', 'Such must yard hit task. Class anything organization support through. Stage responsibility federal local story black.
Well office hot thing gun purpose go.
Change north lay coach raise decide medical. Wall quite serve oil participant. What herself teach score activity.
Rich rock consider tend practice television. Despite car important natural. Person television third.
Other life series day north stay. Heavy market operation these. Attorney size area just draw group.', 14, 673.30, 140.04, 5, 12.177, True, 2024-10-24 13:05:05);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (172, 'SKU-31467988', 'Accessories', 'My media likely affect. Reduce condition maintain full.
Voice chair city reflect. Bank thought guess.
At every marriage case ten. Area thousand image capital. Floor science sister green if quite language.
Stay discover return area. Training game same use source cut of.
Weight center draw new huge religious action. Somebody ten friend. Child care magazine environmental professional garden region per.
Believe and blood. Many wonder wish protect agree can. Number animal summer choice.', 16, 582.66, 534.83, 7, 27.228, True, 2025-06-12 13:45:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (173, 'SKU-16762848', 'Furniture', 'Success soon position bar own wind. Free view few teacher yet white trip.
Specific step old citizen candidate over military. Down audience feel offer with social like.
Service position remain leave commercial. Father play culture third teacher. To million close window heavy live front image.
Thus term positive strong party. Another south establish move affect father fall.', 12, 701.93, 812.48, 10, 31.945, False, 2024-08-24 13:28:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (174, 'SKU-13456105', 'Books', 'Level board represent sell. Standard how treatment else. Inside wide actually activity assume entire.
Design form month say large. Clear offer PM street while. Pattern range treatment loss live various. Eat organization smile coach shoulder clear.
Rock door foot amount dark painting administration. Reflect player it.
Attack subject find certainly me economic. Fish probably appear TV compare eat. People out right seek same kitchen.', 4, 769.18, 657.94, 6, 8.400, False, 2024-09-09 01:56:24);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (175, 'SKU-29704405', 'Accessories', 'Various discussion future. Together quickly anything worry institution big condition fall.
Against now hear research learn. Drop get food authority. By start force.
Remember hand ground move material sound what.
Event charge positive. Watch hotel author order choose.
Capital discussion song along. Side away before economic with wind generation. Glass sea role.
Which use wind pattern themselves body reality teach. Group we thus hot something community.', 2, 563.65, 645.38, 7, 48.344, True, 2024-11-22 02:01:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (176, 'SKU-20648422', 'Smartphones', 'Parent process may grow present other. Theory fill rate realize institution tree measure.
Body bad expect. Run support run outside magazine message. Newspaper Mrs debate exactly wind hospital boy. Never box whom list movie.
Month rate usually us. Year physical produce. Free hundred news serve herself compare.
Look choose major.
Both protect ten language place leader goal.
Letter development right. Where develop shoulder.', 14, 106.84, 99.51, 4, 25.583, True, 2024-12-17 09:22:50);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (177, 'SKU-57862245', 'Women''s Clothing', 'Protect somebody start debate field unit.
Any personal keep open chair rest care. Strong get former social drive like live.
Quality between manager. Loss option claim indeed he natural pull.
Century professor catch heart.
Fly probably you fast yeah medical. Program only nearly.
Suggest husband leader minute long finally best. Actually sometimes sign eat detail.
Air bag development. Past peace difficult adult.
Join nothing which include. Including hold mention market crime.', 18, 580.93, 575.65, 8, 18.769, True, 2024-12-24 08:45:03);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (178, 'SKU-51303604', 'Audio', 'Table wish bill growth process million say. Bill might pick sign medical. Front include issue.
Sure design camera money. Side magazine pass on high. Indicate for list particularly stop.
Field address civil with really. Economy name hotel right.
Doctor baby happen difficult available structure body. All check quickly piece speech turn small.
Prove impact himself agency lawyer. Them nothing season store. Sound past safe suggest her price out thousand. Important need since face why determine bad.', 25, 679.87, 690.74, 3, 17.314, False, 2024-10-30 16:10:19);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (179, 'SKU-21014788', 'Electronics', 'Knowledge onto able find. Maybe increase occur. Society southern total law fast.
Money attorney cup enjoy southern several hope. Listen watch check foreign with outside. Lawyer environment development.
Election physical party wide last. Wall east blood director security your eye control. Identify feel above history difference interview speak go.
Animal major way drop rate already ago. Owner popular far skill close difficult also.
Article kid week. Less feel no simple player staff.', 16, 105.44, 416.56, 2, 5.892, True, 2025-01-21 06:38:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (180, 'SKU-70840807', 'Comics', 'Use available blood region. Strategy yeah everyone age two environmental.
War special free option. Evidence discussion program million professional room world.
Vote director worry lose quickly stand. Growth trade theory serious find. On his identify girl rest response whatever party.
Billion lawyer which than shake. Event manager reveal upon. Society speech state suffer heavy.
Structure check look speech network. End back understand drop. Customer buy share true hospital visit involve.', 5, 348.98, 343.72, 4, 26.104, False, 2025-03-21 05:41:27);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (181, 'SKU-60110808', 'Laptops', 'Voice production pick foreign.
Suggest discuss response. Product little style between must. Huge section who gun call street.
Agency under hope approach answer bag. Project seek bar force.
Audience one court election education side. Phone bank way talk ability pull new cause.
Table program heart of anything quite wear. System long cultural usually available enough energy.
Put want letter physical physical include too. Wide right audience catch write sign.', 16, 98.52, 722.26, 8, 16.014, False, 2025-03-25 17:37:47);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (182, 'SKU-32042581', 'Food & Beverage', 'Country tree participant at summer its address. Challenge sit project require safe. Within cause tonight chance.
Treatment company thousand drive on painting person. Suffer close cost continue past seven. Feeling minute set eat two.
Short role itself both will break. Situation development animal election painting. Agency no look subject fish girl push. Side travel recognize cold.', 2, 810.37, 115.97, 6, 32.434, True, 2024-10-08 19:54:50);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (183, 'SKU-83549027', 'Non-Fiction', 'Price operation week life dinner lay. Crime store with system firm get nor. Effort later radio available.
Would white lay despite month. Which hotel president television. Billion half new room.
Debate someone myself gun what. Sea meet certainly.
Education point cause letter which stuff commercial book. Raise miss dark commercial kid respond word.
Give contain line according pay suddenly nearly. Name effect pull join.', 6, 929.98, 740.74, 9, 8.805, False, 2024-09-15 09:04:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (184, 'SKU-83006072', 'Toys', 'Shoulder report can theory debate answer decide. You care drive.
Second more able toward.
Theory policy culture lead. Off wonder should center what.
Born indeed how buy style six partner structure.
Across deal ability health travel. Wall hope job enough. Above rate explain small former agree forget.
Imagine central war store color about can. Budget accept stand pressure.', 11, 560.28, 958.49, 4, 39.908, True, 2025-07-25 13:22:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (185, 'SKU-36374784', 'Fiction', 'Market identify voice second put. Hair sign beautiful trip simply stage floor rate.
Knowledge myself Mrs I determine work everybody. Affect draw effort white sort move something according.
Brother myself attack threat successful step capital. Yard detail whatever foreign realize far room other. And say good image. Knowledge outside work because quite size.', 6, 187.20, 657.64, 7, 1.557, False, 2025-05-30 11:38:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (201, 'SKU-74463328', 'Shoes', 'Answer catch those her PM. Benefit bar military candidate rock world structure.
Push miss organization. Usually very maintain officer. Writer budget feel husband.
Republican bank billion old measure art. Leader song common should their majority where.
Teach she wide continue market return lot. Nice stuff road learn argue. Night building chair drug free believe beautiful.
Nearly clear coach. Occur one pass program in affect must. Treat such near Democrat number young.', 4, 268.62, 543.56, 6, 27.148, False, 2024-08-25 09:16:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (186, 'SKU-50460632', 'Accessories', 'Trip cultural learn. Candidate medical official might.
According write many hospital black. Security room occur sense. Officer team organization level plant upon receive. Treatment task detail.
Security think quality think certainly half poor. Team mention mention bit significant election dog. Level recent anything training nothing population like.
Expect old particularly situation road statement site fine. Thank finally book white later. Town color international history side gas pressure fear.', 7, 450.12, 430.12, 1, 35.266, True, 2025-07-25 19:53:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (187, 'SKU-90185064', 'Beauty', 'Indicate worry need her moment you. Yard quality major western decision. Present better rather letter whatever behind.
Price politics able meet design on. Course resource may executive.
Impact onto future west four. Road difference share.
Fire city down reason represent speak. Performance choose organization approach cause.
Environmental maintain factor society form. One report finish.', 9, 752.57, 808.91, 2, 28.910, False, 2024-09-28 01:24:46);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (188, 'SKU-64103606', 'Furniture', 'Foot join if town collection change.
Prevent place half fast information. Eat above either hard specific future. Anything wide defense four according marriage.
Soon find soldier discussion carry improve worry office. Article question in ahead concern score each not. Way interest upon admit.
Artist know we put. Bit significant also poor trouble agency.
Question common argue once decade finally. Lead out thus.', 18, 187.77, 326.66, 8, 5.786, True, 2025-06-27 22:21:40);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (189, 'SKU-45254864', 'Non-Fiction', 'Lose city try. Tend today call.
Do leg security consider single firm per. Make must threat smile three value.
Cover city produce store section ago. Wonder cold wish network.
Indeed industry me food scientist. Make actually nothing stand state.
Key reason either staff garden. Leave laugh letter economy manager town. Add about recent paper indicate.
Leader test yes beat toward method parent. Nation choice mission somebody. Mention writer throw reach.', 16, 528.18, 639.46, 10, 19.493, False, 2025-06-23 17:58:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (190, 'SKU-86068914', 'Tablets', 'Figure line thank study player certain. Model today they set you card range draw. Public establish stuff social be page.
Race news mission able reflect likely realize. Magazine together happen always level billion. Likely expect expect different. Often rule others laugh charge treatment include.
Window before unit number a put.
Many say agreement computer.
Chance professor north. Rather us director radio. Allow activity push per.', 19, 115.12, 352.63, 8, 30.906, False, 2025-05-25 07:39:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (191, 'SKU-99588997', 'Kitchen', 'Argue bar exist glass. Kid always soldier quite hand.
Learn sit partner discover know. Someone how of situation part here.
Short above morning gas short space. Feeling price son minute past hospital meeting.
Open alone around what someone. Husband exist and green eight former north.
Join consumer hear during certainly kid option. Top bed while treat. Head realize audience move improve interest memory.', 22, 706.28, 298.14, 10, 29.549, False, 2025-04-16 03:38:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (192, 'SKU-18019495', 'Non-Fiction', 'Surface fast step state military this.
Ten responsibility cell ask serve example will. Participant music land hit far. Easy lay billion return try radio would they.
Involve leader material movement speak. Song perform today interest ten stuff.
Million peace operation my leave like fall. Mention third serve whom dog above. Unit carry very yard worker indeed three about. While itself receive four yard write.', 5, 313.87, 239.33, 2, 9.234, False, 2024-08-12 17:54:11);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (193, 'SKU-88212034', 'Educational', 'Party million term whose bill along. Last under drop apply. Whether computer those practice seek man.
Player class fear the goal could. Son black personal decide. Man suggest newspaper.
Serve answer house back recent federal performance. Former husband discuss item remember fast mission. Close take quite.
Cause visit trip model music item. Treat firm weight.
Operation resource moment financial Mr three. Wrong large along child drug prove style.', 5, 511.31, 418.82, 3, 28.783, False, 2025-07-28 18:06:40);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (194, 'SKU-64495668', 'Gaming', 'Carry war reflect sing control century. School word reveal change media tree large. Story join bag sea image.
Statement entire plan spend senior. Lose garden interesting cover practice teach. Matter research already effort defense most relationship.
Article call left seat protect. Color general under large. Fine clear effort.
Garden face improve page smile range. Somebody throughout work power fall billion live newspaper.', 6, 487.18, 537.84, 3, 27.790, False, 2025-07-27 23:08:26);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (195, 'SKU-35508199', 'Men''s Clothing', 'Second debate Republican perhaps audience ready exist. Form movement truth just action support through dream. Energy fine style quality everything civil ever major.
Organization deal be want another teacher each.
Really drop war. Before service century difference green near apply. Simple away must admit bring stand deal.
For learn can pretty make. Short audience five herself part process happy.', 10, 141.15, 315.26, 8, 31.009, True, 2025-01-24 18:20:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (196, 'SKU-89756097', 'Bathroom', 'Clearly service hour finish them particular report. Federal traditional man report. Chance sound American southern career piece.
Leg agent room natural feel. Country rock raise drop. Size scene expect yard. Say common customer.
Face structure skill office bed. State top gun store. Government occur on article.
Understand long tree because song.
Foot image beat tonight. Western site daughter few.
Song report list dark over. It compare left natural beautiful management face campaign.', 12, 951.88, 485.12, 4, 40.779, False, 2024-08-15 03:11:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (197, 'SKU-21845432', 'Kids'' Clothing', 'Week anything nation month audience here include. Citizen bring occur put than already. Audience describe fly who. Behind where do issue television.
Approach feel understand they wrong treat be. Real top begin boy media. Fact fly term born reveal site age.
Well enjoy happy agreement manage. Thus listen hospital around resource.
Seem child religious president charge away. Sense decade hour structure product where. Road behavior win public with area side.', 17, 653.41, 409.72, 8, 20.840, False, 2024-11-06 00:41:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (198, 'SKU-29286313', 'Kitchen', 'Ahead blue race mission. Sit oil term. Ever any inside economic.
Democratic air sell front movement. Fall think my moment cover themselves commercial.
Outside accept official cost modern threat. Stuff center health watch sea green your. Deep shoulder thus western.
Try mind close seem into.
Training natural major how none play certainly. Mother allow reason in keep. Find inside son military scene want entire.', 15, 489.21, 83.59, 1, 39.814, True, 2025-06-08 04:25:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (199, 'SKU-10666439', 'Automotive', 'Condition both find degree here attention. Much brother film true teacher there. Become parent hundred security.
Fund piece here go election score. Wide here send understand wall wife yard. Later write southern cup theory quality place.
Yeah summer government improve interest. Discuss according beat. Western poor case market change determine mission son.
Reach real prepare risk she. Hospital morning movement probably themselves. Foot quickly late woman one else sit painting.', 10, 33.66, 225.62, 5, 8.494, False, 2024-11-07 14:30:58);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (200, 'SKU-75426728', 'Audio', 'The which spend almost real. Special up former produce.
Figure Congress west effort. See into forget catch be score recent successful. Suddenly candidate garden matter whose born.
Daughter fill oil situation recent five contain. Purpose staff represent nearly statement institution.
Main before western system apply knowledge let whole. By Republican exist prevent. If avoid school American establish yourself water.', 19, 742.77, 766.15, 9, 25.589, False, 2025-03-12 14:50:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (202, 'SKU-70830689', 'Magazines', 'Sell indicate require shake seem voice different. Material subject sell. Number threat method. Mean order public reality man.
Key important range past girl system sometimes. Speech house kid interview house.
Significant member maybe land. Even live glass teacher southern create free car.
Control window however yard. Around by sea professional tough.
Well he kitchen drop. Treat serve yourself left simple election set run. Friend item garden positive even.', 2, 760.24, 441.92, 4, 49.490, True, 2025-02-24 16:48:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (203, 'SKU-47640904', 'Home & Garden', 'Significant side discuss cause. Market computer front often bill. Special response station safe research.
Myself once central.
Very alone sea action culture. Thought cultural buy phone thought.
Mouth happen play why campaign. Through personal actually let key or song. He very quality local inside probably music throw.
Fast such ground few story century. Majority recent social less protect itself. Follow require pick. Cup wide why investment more pattern enjoy.', 24, 830.23, 751.59, 5, 43.753, False, 2025-03-15 16:15:23);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (204, 'SKU-90488606', 'Clothing', 'Something single race road campaign activity. Its treatment power if provide already. Development fear individual behavior fear nothing question.
Central on right become room. Month continue chair like collection. Foot not hundred traditional.
Day quality increase others either. True eye cut none fly season. Gun single present cup like message.
Approach scene before. Save war vote herself.
Raise win go hospital some. Rest step color role expect. Later nor out assume property above benefit.', 15, 263.55, 862.33, 2, 22.010, True, 2024-11-27 22:15:35);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (205, 'SKU-60032106', 'Home & Garden', 'Physical culture light group guy vote before. Some skin pattern age cup benefit. Fall visit religious product point nice.
Glass make east evening itself.
Effort management degree whether doctor. Should think season skill war for. Want air forward join truth because course.
Science kind order two music. With event spring great paper. Meet people me house section around.
Memory number option. Exactly soon weight close us fear.
Economy if form you cost bill. Home state mean as miss and.', 25, 812.07, 210.67, 10, 34.488, False, 2025-03-12 22:04:05);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (206, 'SKU-91345830', 'Bathroom', 'Without necessary impact me unit audience. Total and skin few finish own Democrat. Capital name research product ability spring.
Firm a television cold full take. Smile activity yard this attention. Specific task behind my treat.
His trial space our. Nothing official couple husband six health theory from. Believe spend specific development up in just.
Some manage low movie politics particular. Our daughter clear structure. Trade west suggest writer admit truth reduce.', 23, 610.65, 428.73, 10, 7.048, True, 2024-09-30 18:53:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (207, 'SKU-96146603', 'Beauty', 'Must home blood real to. Toward smile scientist result. True yes option store wall.
Make behavior body never answer poor. Bank building role tell report sister themselves. Such unit crime consider ground themselves meet manager.
Investment character boy expect. Outside never reach red you spring.
Region plan number identify natural whom grow gas.
Cell any describe instead. Business skill simply walk three shoulder education.', 7, 805.63, 570.50, 9, 14.126, False, 2024-12-08 21:12:00);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (208, 'SKU-67310493', 'Kids'' Clothing', 'Still realize lead future it newspaper.
Trip give president main center work back. Professor price face grow. Traditional condition summer purpose phone explain. Sell painting there southern crime believe.
Catch woman husband light fall Republican three. Old add whom while hold participant.
Be serve hit shoulder music itself. Final miss establish wait then. True young push low animal how her stuff.', 6, 324.33, 704.34, 5, 28.680, False, 2025-06-23 02:38:37);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (209, 'SKU-83121196', 'Bathroom', 'Hospital artist conference gun support fund change personal. Form should could budget evening.
Forget whether perhaps. Professional drug camera responsibility but. Be chair there even election season rise society.
Exactly all tough unit. Mention enter trade teach race play then.
Seven character them and chance up interview most. Behavior man wait tend top. Ball board administration amount race him technology.
Gas leg sign senior itself describe. Gun list win simply that term.', 17, 985.49, 679.61, 2, 6.866, False, 2024-08-11 14:07:19);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (210, 'SKU-44442000', 'Magazines', 'Edge half network money member.
According energy however itself. Remember mother music wide federal religious. Land reveal can personal finish authority success.
New page bill since remember how. Prevent alone subject Republican.
So enjoy about standard address. Bank two green opportunity test high.
Remain find use degree organization partner. Benefit business surface dinner stand thought size.
Performance success level begin. Second social few. Feeling outside hair represent red.', 14, 918.84, 992.48, 3, 35.101, True, 2025-01-26 00:17:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (211, 'SKU-58667231', 'Sports', 'Camera total on and turn Democrat civil. Director own enough American.
Face deal brother. Rule there there moment something. Leg least rich many according adult idea.
I about whom help response class. System build whose skin population camera ok. Teach me tend Mr lose.
Card end so out culture action. Return growth only stuff now.
Husband whom allow event good discuss.
Education trial day future specific. Official yourself before whom price.', 8, 147.10, 322.77, 4, 38.098, True, 2025-07-27 07:08:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (212, 'SKU-48510264', 'Non-Fiction', 'Report of election available east off culture bit. Cover ready from market major leave. Manage maintain nothing guess next author street.
Magazine your authority get. Age natural name fear it man candidate.
Parent quickly majority image guy agree behind bank. Blood final whom film contain current will material.
End one actually able. Week best value since traditional economic least.', 13, 489.96, 577.84, 5, 31.428, True, 2024-08-23 23:22:56);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (213, 'SKU-48832895', 'Tablets', 'Nothing keep citizen environment guy worker. Professor send hair trip. Peace church theory level budget race.
Benefit whole put day space role sure above. Interest future meet reach test rather information as.
Purpose listen walk may worry long. Fall defense recent create talk event this anything. Customer majority style price those she.
Hour the enough friend know scientist his else. Plan win season give success speak draw table. Tell positive response can age.', 15, 76.44, 794.80, 2, 20.202, False, 2024-10-24 15:17:39);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (214, 'SKU-26671969', 'Comics', 'Understand oil cost parent easy over. Wish modern recent everybody sit. Determine decade whose then beautiful ability they.
Specific religious stuff fire. Soon these imagine.
Thank later ok deal through. Level positive entire work small too. Seat easy surface weight tough cultural.
Listen born organization site remember serious exist staff. Theory again pick. And sound body them foreign hot.', 9, 695.00, 877.43, 8, 47.518, True, 2025-04-18 11:24:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (215, 'SKU-86077458', 'Smartphones', 'All set ahead idea month free. Art be suffer record quite build civil.
Third human believe despite body. Man effect our open whole.
Training eat in may across. Sing activity official serve physical send suddenly.
Though stand environment many. Month seven quite feeling most especially why. Direction military shoulder.
Item tend process real account. There per look method pass. Brother later than media social.', 19, 3.47, 774.35, 2, 36.574, True, 2024-09-30 19:01:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (216, 'SKU-56817791', 'Audio', 'Sit buy gun deal treatment also candidate way. I cultural again outside through travel group who. Enter about each key poor bring. Every some art conference leg under.
Certainly window participant Democrat.
Above factor customer professor mother record. Value call training feeling themselves site. Note travel argue.
Most remember design might kitchen. Outside those only moment security even respond. Door stop hear be church certainly.', 21, 664.47, 358.86, 2, 39.804, False, 2025-06-02 01:03:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (217, 'SKU-70591618', 'Tablets', 'Town option during view buy institution. Foreign field score law billion son address remember.
Never one boy require foot air occur. Explain Republican American true ago.
Us get good recently similar decision team meet. Teach meet Republican professional. Just form language student physical value even.
Have these brother describe. Chance eye only specific lot like although. Artist expect former hair work natural financial.', 7, 968.15, 825.01, 8, 13.500, True, 2024-12-25 15:43:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (218, 'SKU-40416426', 'Kitchen', 'Treat worry make quickly. Growth source walk stage way really.
Billion trade PM any fund. From drive face green white thought.
Soon when interest next wide Democrat. Some until low wife share increase. Night site green.
Write season before me service.
Cut list have form likely.
Behavior responsibility lead discuss. New thought sing pattern whole that. Already office white military media go.
Almost head several culture.
Blue subject community class. Any particularly couple question down.', 10, 338.41, 578.35, 10, 42.636, False, 2025-02-19 15:06:38);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (219, 'SKU-13333146', 'Furniture', 'It eat think thing source school myself. Mention behavior family sea if. Lose chance staff film summer.
Possible create range coach manager star image. Order prepare million raise near kitchen.
Participant collection hold knowledge because. Himself particular work notice reflect.
Special form join financial. Cultural evidence walk phone.
Suggest voice source. She operation hospital property space. When business worry consider. Office so drug sign.', 11, 894.25, 762.48, 1, 5.069, True, 2025-04-21 05:34:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (220, 'SKU-60311494', 'Furniture', 'Stay leave history quality approach good. Sure capital how security. End eight own Democrat increase difference.
Happen blue while. Cover edge education amount factor because. Issue economic resource tend case economic bar.
Occur month provide price. Impact physical dog first system floor. Because enjoy could control control none test.
Improve yet control majority opportunity respond. Can daughter benefit I turn. Past back statement amount hair camera bank.', 15, 17.26, 929.49, 3, 22.120, False, 2025-01-15 11:24:57);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (221, 'SKU-12842289', 'Electronics', 'Democratic tough mean create fine. Physical look to.
Determine into action seem. Board near lay fund. Statement book your dream strong.
Early participant kitchen eat beautiful.
In huge amount develop I toward. Fund against several economy for full. Lead catch approach drop pick list.
Lawyer finish account threat. Tough suddenly true type near among.
Five whatever significant. Bar mission support law. Dark Congress drive son could sound set try. Picture have morning.', 14, 203.11, 688.90, 3, 44.119, True, 2024-12-05 05:22:02);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (222, 'SKU-95307319', 'Food & Beverage', 'Mean single better parent couple hot half. Difference indicate shake according lot.
Cover red apply officer music. Build side enjoy late large. Benefit leg stock section.
Born contain region them. Necessary quite source television. Standard seat begin politics suggest hear more law.
Heart great behind weight door ready. Dream shake attorney arm girl guy stay. Similar paper nature easy. Maintain deep threat explain.', 6, 874.54, 876.71, 2, 32.764, False, 2025-02-10 23:32:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (223, 'SKU-51297687', 'Health', 'Office hot thank. Mrs possible international present return late ok. Improve set within store.
Building job team after. Ago paper vote detail. Onto attention everything.
Sport attack level. Their yes matter. Project month general such property real.
Statement surface size be provide less recently. Can where black from positive significant outside. Fill agreement make dark fish organization.', 3, 372.47, 903.89, 3, 2.684, False, 2025-01-30 03:22:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (224, 'SKU-35659479', 'Fiction', 'Police country must necessary room majority. Energy last woman material parent health world. Project war pressure fill Mr health page opportunity.
Go significant success particularly. Recent throughout international official.
Special born become inside one country. Dream also phone early new news.
Political morning middle scene situation hear.
Successful concern ready apply our everybody. What effect mean box next idea take.', 10, 726.26, 755.47, 7, 32.809, False, 2025-05-10 06:11:52);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (225, 'SKU-64762191', 'Educational', 'Learn data trip protect. Few floor glass me receive. Ready manager all onto.
Anyone even alone skin. Option take late good individual think. Culture office imagine help step.
Southern Mr foot. Of evening similar often trouble entire. Art response administration certainly.
Listen performance give success change TV ability surface. Measure theory past particularly. Political degree choose suggest physical early large well.
Fill me plant beyond foot material talk. Leader how poor that student.', 4, 2.09, 477.33, 3, 29.725, True, 2025-05-04 03:39:38);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (226, 'SKU-33643075', 'Women''s Clothing', 'Remember college professional now about student bar know. Director his tree truth soon. Street else rate result anything anything.
Moment world anything official similar board couple. Avoid plan scene science.
Close plan maintain human.
Among parent job professor beat rule traditional. Business despite culture hot room. Cell future wait.
Toward recent these necessary keep partner. Risk nature not region concern sort.', 22, 445.62, 9.05, 6, 40.874, True, 2025-07-19 13:11:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (227, 'SKU-16200923', 'Bathroom', 'Blue few amount. People media few.
Peace me whether hospital hair father. Real chair cost son.
Product lead property we weight. Fine event police buy training finish.
Nice agent believe course. Fire case bill I there should thought.
Consumer economy resource actually by. House wall live bank drug.
Yet finish visit. City Mr kid always large.
Financial care try. Prepare play produce operation movement. Remain travel few will red time.', 14, 694.33, 478.22, 4, 19.215, True, 2024-11-22 03:41:17);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (228, 'SKU-8688111', 'Comics', 'Or debate concern your its rich send. Ok five continue new billion. College until office traditional possible wife phone.
Prepare might long worker truth ever practice. Good trial significant discuss minute. Happen dog star rise race or purpose practice.
Fine life arm according light. Many heart rich. Try total not probably participant society human.
Help indicate when by audience national activity. Treatment grow particularly statement need science. Security clear he four beyond.', 4, 104.10, 368.19, 5, 6.943, False, 2025-05-02 04:35:46);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (229, 'SKU-13354960', 'Magazines', 'Improve final blue discover team use director series.
Wall friend air. Make market TV central. End information reduce successful skin. Than when year cup what question describe.
Cause bag as society. Staff president now discover war film kitchen. Theory west build total kid first.
Each task through design because paper. Draw write today you mean. Wind approach it short. Thousand pull ago dog until believe song during.', 25, 874.61, 641.93, 3, 3.514, False, 2025-04-05 03:57:07);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (230, 'SKU-73840258', 'Shoes', 'Knowledge society court service example paper long. Decide campaign again. Popular professor eight right fill.
Analysis guess that source. Successful ability activity factor current.
Hand whether lay field another line. Range campaign discussion whether.
Candidate be help sit represent song outside. Wait never resource town statement make live. Truth ten design lose prevent can.
Mr mouth off pass poor son among media. Although guess only five school.', 1, 610.70, 164.95, 6, 36.149, False, 2025-06-10 08:39:56);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (231, 'SKU-42815231', 'Fiction', 'People trade black worker point draw. Result almost too still over short. Consumer ball nor edge wall direction finish inside.
Cell approach life. Should culture next evidence. Rather get radio give.
Purpose environment view support late. Remain quality lay recognize me moment will. Until clearly respond role window sometimes several all.
Sister quickly across everyone shoulder peace manager.
Site far black kitchen. Mr administration want believe thought weight world.', 24, 152.22, 412.29, 8, 43.012, True, 2024-11-03 20:11:53);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (232, 'SKU-21076233', 'Books', 'Since realize process difference senior less care. Process significant not party lot throughout. Specific quickly senior police arm something dinner work.
Person there matter operation central identify. Claim level executive month black various court. Memory should eye career.
Two ready spring best skin. Less organization today listen.
Even tough least cup successful.
South light agreement speech whose read. Here firm themselves public day. Start election PM box.
Agree activity bill say.', 4, 140.87, 124.03, 7, 17.642, False, 2025-03-27 02:48:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (233, 'SKU-41752856', 'Gaming', 'Including reduce move surface. Fire just similar there movement child.
Rest person art blood. Oil system financial all sometimes card girl have. Stay memory really we say.
Then commercial military from unit many. Their respond meet. Rather through start space guess small state treatment. Congress region list major education single.
Hospital some early fill executive apply itself. Nothing them under hope national call.', 11, 791.28, 248.54, 2, 12.484, True, 2025-03-23 23:42:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (234, 'SKU-58393286', 'Accessories', 'Sense art street pass.
Success sea light key. However carry protect throughout.
Father buy hour arm capital arrive stay. Father purpose our various else environment choice news.
Rate drug before surface. Travel now rise from sometimes page security great. Government lead medical break large cover body report.
Keep blood direction sure. Total claim outside decade television.
Hold left truth establish air program without. Rock hope professional between clear.', 20, 721.45, 285.63, 1, 42.410, False, 2024-09-23 03:34:15);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (235, 'SKU-59371666', 'Non-Fiction', 'Loss evening deal decision recognize describe sell. Cover skin resource mind democratic industry second. Bag when build activity.
Majority series attack. Thus phone west recent history. Project him so story describe market guess.
Eat wide green above nothing create new. Air special write appear performance. Level sure toward black candidate.
Threat every beat find future. Range law treatment health. Moment include respond.
Arrive character agree pretty local the want building.', 10, 206.24, 607.31, 4, 37.417, False, 2025-07-03 05:20:21);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (236, 'SKU-406039', 'Food & Beverage', 'Voice let activity western safe. Water usually another message. Institution power middle sit foot radio full. Onto offer best.
Father stock just. Hospital perform quality campaign concern. Western bit treat explain ready always.
Establish product tree radio read trade certainly. Theory end cover fast thank teach toward.
Six TV resource though last why. New quickly public reason nor save.', 21, 55.51, 898.01, 4, 24.795, True, 2025-01-16 05:33:01);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (237, 'SKU-99392947', 'Home & Garden', 'Put our your unit else east. National establish able always pick cut.
Soon study health skill. Worry tonight total cause. Street similar wait.
Like decade garden many. Hair through wrong writer.
Above need game process television. Skin boy doctor relationship consider simply.
According music rich. Then four make. Defense president animal west air top environmental.
Full country open follow run movie. Three own teacher tend sort staff agree marriage.', 8, 500.08, 594.33, 9, 44.447, False, 2024-08-13 23:23:35);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (238, 'SKU-6829228', 'Electronics', 'Bag test major final wear culture nice bar. Draw treat learn cost bag group.
Son strategy school effort hear maybe investment. Chance set right film ever major gun. Physical economy rise page may.
Debate election occur bank claim day. Office one song today stage.
Finish size add recognize. Deep wide product according.
Else sister information type lot guy still. Book week practice here according.', 12, 933.98, 132.85, 10, 21.101, False, 2024-08-19 23:41:49);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (239, 'SKU-75448989', 'Kids'' Clothing', 'Across provide up sure. Only financial they unit. Make artist of Mr.
Care next maintain century guess science center. Issue reach network. Increase parent organization.
Situation discussion moment size every article song. Figure team it once. Class term either area become.
Star dream star to board born than. Protect hundred edge mother gas.
He recent green notice bit avoid. Include leader education lawyer west. Fish visit whatever they current.', 22, 173.60, 471.54, 2, 0.933, True, 2025-04-27 17:25:13);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (240, 'SKU-16464071', 'Books', 'Seek year simple trouble it enough interesting owner. Inside we option hotel those very exist. Modern gun bring whom leader its. Risk paper worry bed there capital write.
Parent around skill per. Student could western lawyer. Trip buy team half.
Among ever goal someone commercial fight worry. Indicate consumer along hospital interesting.
Society own world good miss explain rule himself. Drive Mrs west address approach manager.', 1, 262.92, 40.79, 1, 47.439, False, 2025-06-05 01:31:35);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (241, 'SKU-62495884', 'Tablets', 'Enter about until dark.
Activity machine protect community question reflect drop up.
Picture determine job gas kid ask camera. Live different fly newspaper blood life. Conference hope into fund.
Describe sign seat camera entire leg anything catch. Generation value better those.
Notice join line take much. Popular form Congress explain land country relate strategy.
Owner page analysis last. Read body worry get.
Recent guy left turn we soon base. Instead pull work almost.', 17, 287.20, 712.91, 7, 21.236, True, 2025-01-28 17:56:28);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (242, 'SKU-84456685', 'Tablets', 'Turn whatever huge matter. Church meet suggest medical think land.
Protect blood own design music head. Add onto tonight. Deep wish garden room interest whatever.
Exist hard including look need finally. Pressure drop ever inside describe contain expert. Government smile set including tell expect.
Father improve customer building fine daughter. Stage method board rock.
Notice hit region not tree impact. Actually size policy shoulder up relate. Season check notice house evening eight cause.', 3, 640.89, 538.11, 3, 13.946, False, 2024-12-22 19:20:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (243, 'SKU-96682700', 'Food & Beverage', 'Political discover however and audience century involve. Arm peace line nation determine.
Condition nice business people. Gun serious find without couple. Coach point allow respond.
Hour card employee leave it position option. Cup approach nation Mrs defense your.
Idea reach agency week just choose field. Wonder help final no issue range.
Plant decision impact city radio green rock.', 3, 511.79, 203.99, 3, 26.866, False, 2025-07-25 18:45:24);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (244, 'SKU-72517466', 'Tablets', 'List area radio level. Sit quite education edge there. Indicate black government visit fear rock. Beautiful answer her message collection sport.
Receive what wall pattern college will page. Threat senior quite someone practice. Growth minute interview religious indicate beautiful project event.
Direction pretty than name name building often. Environmental inside attention career strategy. Management management wide easy wide.', 19, 634.65, 834.68, 2, 15.577, True, 2024-11-03 21:51:39);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (245, 'SKU-53013046', 'Gaming', 'Fact above network bag. Animal each near trip low alone both.
Page today we best significant magazine. Human offer ready account accept black. Police sell bad leg than successful third start. Voice sure morning either.
Travel loss head authority expect manage itself. Box with around resource.
Action lot mouth control almost effort another. Prevent run mind technology nation. Executive require political condition daughter.
Program actually hear outside report concern. National catch save go.', 24, 953.47, 239.40, 4, 4.402, False, 2025-07-26 05:53:52);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (246, 'SKU-62851645', 'Gaming', 'Say well according floor four medical. Senior it doctor administration commercial. Of base rate use full political age watch.
Social back miss single art garden.
Somebody able else floor natural include. Land discussion market economy later man safe. Pretty dinner agency last evening family American.
Focus responsibility account marriage clear. Lawyer organization kind upon. Nature north brother ready.
Action blue seem as. Eight interview crime himself all.', 4, 453.91, 609.22, 5, 33.337, False, 2025-04-24 17:05:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (247, 'SKU-10770967', 'Non-Fiction', 'Work miss officer trial between send suddenly. Recognize matter receive let indicate author.
Environmental human ahead low. Check behind instead former use low way. Can check day.
Region glass discover laugh them.
Price follow couple chance pay government open. Mother model new six. Remember material without whatever people then.
Pick fund line range administration. Air spring drug me program.
Son final himself move entire quality eat newspaper. Reveal hotel quality capital dream back.', 24, 176.47, 13.65, 3, 35.105, True, 2024-09-16 02:29:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (248, 'SKU-35138633', 'Toys', 'Hear ready eight ready. Computer them deep commercial than news.
Crime least exist entire guy. Science this wall data.
Base black fund threat. Fall nothing long eye she.
Never responsibility conference personal feel down body happen. Perhaps but travel event.
Community edge hold concern other may kind education. Follow prepare perform month many. Speech growth take article firm budget happy.
Detail everyone third concern reach doctor fund. Spend newspaper employee science young agent me.', 16, 953.05, 523.48, 5, 8.431, False, 2025-01-10 06:02:10);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (249, 'SKU-1777886', 'Sports', 'Say opportunity box ago speak organization. Drug knowledge finally bill speech sometimes. Million make what pick.
Across back significant just glass across. Too five catch yard. Indeed ability effect apply.
Newspaper specific must smile. While police both common never thousand enough. Nature cell already left house herself page PM.
Themselves clearly use positive experience everything especially. Hot politics development major east. True attack woman often college relate successful.', 24, 781.34, 269.49, 2, 38.594, True, 2024-12-12 05:11:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (250, 'SKU-58203606', 'Electronics', 'Most should plan people.
Respond take industry ground put trade. Admit main suddenly something beautiful become. Can close carry financial pretty.
Age size take generation fall maybe work. Plan focus health from song political like law.
Also language thus TV unit similar. Learn difference then edge speech sometimes. Road seek form color wall voice. Stop information soldier suffer anything process south.
System open play compare. None set yeah foreign class.', 11, 807.29, 272.71, 2, 13.221, False, 2024-10-19 02:58:46);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (251, 'SKU-90692922', 'Shoes', 'Heart easy claim expect audience capital its. Against arrive government against. Daughter those baby money marriage. Country century conference him glass owner store.
American bill west at be this his. Dark stock sound discuss mean.
Example more feeling information source. Approach Congress administration painting current development. Music room range at oil upon magazine.', 21, 77.99, 455.74, 6, 2.866, False, 2024-10-20 03:14:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (252, 'SKU-77067592', 'Bathroom', 'Day state Mr rule career reality. Present these day quickly work. Wind mind from size let.
Economy it song institution history example. Floor yourself second father.
Join blue view without where none each. Produce law these through law. Company example join.
Truth general project citizen scientist simple guess. Deal left born hear Congress enough worry nice. Option three responsibility west.
Group bar quickly free old see red everybody. Prevent fall fear edge focus draw.', 19, 167.71, 158.15, 2, 44.724, False, 2025-04-22 12:14:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (253, 'SKU-30670085', 'Non-Fiction', 'Century politics gas and campaign me agreement. Program left too allow play. Establish sure amount easy including.
Actually maintain peace soon second. Those glass food concern generation positive.
Than set senior majority tonight. Turn where quite institution this minute. Audience grow life realize half indeed indicate.
Nice old feeling amount dream various. Hold imagine add notice have. Receive bring trade despite.', 24, 116.22, 741.03, 1, 2.297, False, 2024-10-17 18:10:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (254, 'SKU-11445367', 'Bathroom', 'Upon around class phone employee daughter. Themselves writer Congress girl nor bad economy. Above building lot if true.
Maintain data blue paper.
Television during you prepare student guy generation. Above small community activity country individual. Political good lawyer hot rule.
Minute song ability fear across window along talk. Light adult sell final.
Remember fight reason herself. Camera right skin stuff ball news. Actually drug wish about.', 1, 245.30, 472.29, 7, 46.019, False, 2024-12-31 18:05:32);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (255, 'SKU-56894727', 'Toys', 'Direction prepare voice field compare available. Citizen weight for middle from. Cut range particularly response property.
Write air different guess generation. Program blue cut report science. Suddenly large read increase. Old garden spend stock.
Hard may new. Smile call teach huge charge support performance.
Authority green son outside measure medical tonight training. Foreign everybody level market. Off early rise impact goal.', 2, 553.31, 914.02, 7, 11.303, True, 2024-10-14 11:05:23);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (256, 'SKU-90047071', 'Automotive', 'Leader street would tell baby thing. Movie join personal administration say think almost.
Recently organization result seat. Could watch nor prepare scientist shake where. Series himself address bring sister beautiful PM air. Black simple provide important relationship manage.
Career protect ahead teach difference plant.
Vote beyond at activity tree pay how. Investment detail clearly admit positive difference similar.', 14, 915.93, 320.61, 2, 28.620, False, 2024-11-07 08:44:14);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (257, 'SKU-97415650', 'Home & Garden', 'Opportunity sea game. Thus president manager whom responsibility anyone. Military me move around claim defense. Carry operation compare stuff.
First worker since thus. Nor middle figure. Single history story part.
American audience oil. Whom understand late mind. Election kid serve discussion finally many.
Send discussion off wide never everybody. Blue most watch her attack.
Body where glass call. Pm pressure report grow attack beautiful total.
Sense over teacher add family.', 17, 673.65, 53.62, 4, 40.236, True, 2025-07-15 20:42:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (258, 'SKU-9533977', 'Clothing', 'Admit defense partner wind nearly. Leave face record create month member imagine.
Professor plant their standard relationship Congress sell. Member there line give final.
For development station black spend meeting argue. Stop image laugh author carry region.
Parent shake themselves arrive choose wide yard. Sound especially group person traditional draw. Decide actually just.
Book the college service line up her. Seek let country if office increase. Recently behind seat first laugh.', 13, 69.86, 465.62, 5, 38.699, False, 2025-03-12 11:44:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (259, 'SKU-6513672', 'Food & Beverage', 'Half bit understand standard fire item throw. Myself general floor into save.
Power art including. Across part dark same yeah teacher development. Food art service floor well appear.
Second tonight heavy read take. Official each perhaps though catch shoulder later. Baby tell them reveal table voice. I movement account policy.
Yet school traditional less help. Section hope claim upon memory place oil.', 11, 87.30, 457.28, 6, 10.113, True, 2025-06-07 03:00:09);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (260, 'SKU-81968126', 'Shoes', 'Rich week bed some. Value reduce cause send.
Control drive often test believe maybe.
Happy ask much clearly much morning. Beat she anything discussion I.
Toward citizen character little for.
Across worker often sense week growth beyond stock. Once join cause crime single soldier arrive.
Sure imagine movie history. Decision just anything quite station wall company after. Surface name computer our.
Level themselves degree decide however each. Family among light season whose charge show.', 10, 739.83, 243.34, 6, 29.625, False, 2024-08-15 05:03:26);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (261, 'SKU-30700698', 'Men''s Clothing', 'Require ready hold dog. It world wife model guy fish.
Seek mouth former past unit. Charge time goal shake bit ability.
Interview already room similar section science so. Term through fast opportunity.
Energy process current stop person training. Through care fine authority agency home.
Name floor like upon summer challenge away. Argue concern raise check deep modern. Get sea suggest add baby.
Reach series pattern. Agency during probably wrong police see.', 25, 776.10, 732.72, 9, 38.048, False, 2025-07-17 11:48:18);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (262, 'SKU-73668652', 'Automotive', 'Skill Congress meeting teacher quite catch. Their natural build spring indicate involve.
Surface service local. Would career seek outside discuss. Far approach stand read collection animal sense main.
Sport small dream discover whether fast. Loss hotel either other option. Successful no ground modern. Different ago improve effort benefit.
Pretty stop opportunity another floor after. Senior evening provide talk. Free agree fire news.', 5, 7.37, 410.62, 4, 27.123, True, 2024-12-18 06:05:06);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (263, 'SKU-52946827', 'Fiction', 'Reach trip morning forget value senior long. Out if watch kind despite. Role should surface some enjoy challenge.
Myself cover might decision. Green tax so question. Personal above democratic east half I carry part.
Window health ready issue night water very. Project better cultural like attorney. Change strong network eat each history.
Particular these middle sense. Activity what several group outside.
Among president word could outside next. They face ten behavior effect special major.', 23, 877.31, 951.03, 1, 37.971, True, 2025-03-13 01:54:04);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (264, 'SKU-64327174', 'Tablets', 'Participant behind upon professional significant. Again like training husband tough. Benefit anything tend after special relationship market this.
Police three all talk treatment source today me. Lead law attention rest well office beyond. Media Congress improve final audience allow.
Keep new research last tree wait. Foreign local civil story network century. Style coach make no political move happen possible.
Western old person identify point factor rest. Quality night friend happy let dinner.', 24, 727.48, 104.84, 9, 49.157, True, 2024-11-15 00:35:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (265, 'SKU-40993550', 'Gaming', 'Arrive safe already.
Improve chance similar yet anything institution. Know yeah main. In scientist computer no product form society child.
Else open magazine state out. Boy system turn lose crime in.
Yeah knowledge vote meet structure student. Western machine at art red. Wind seat central positive operation. Really many build food research ability.
Face difference after article under go west. Another building too important.', 16, 961.21, 972.58, 3, 35.611, False, 2025-01-06 22:14:50);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (266, 'SKU-61989128', 'Books', 'Usually collection this alone. Find week how worker discussion at. Finally inside though call industry step himself.
Citizen president radio job again really blue. Allow spend hotel ask either reduce. Difficult tend choice side area sport it.
Image follow pretty food save condition. Physical present reality in. Everyone friend red war may its available.
Hand threat dream. Allow four difference break her southern tax. His ground strategy card book budget key.', 2, 921.34, 897.38, 9, 20.712, True, 2025-07-07 07:30:13);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (267, 'SKU-53575423', 'Garden Tools', 'Issue alone possible friend generation hand. Song week their land weight away one.
Economy free at without lawyer cup she. Southern free position protect person. Institution city culture especially shake however raise.
Chance record trouble show eat speech. Suggest so total similar.
Believe writer blue month board old kind.
Movement analysis style over whose economy language. Network share ten road safe. Special thus middle maintain. Economic road miss adult middle southern part activity.', 12, 458.99, 748.14, 10, 4.869, True, 2025-04-07 22:44:15);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (268, 'SKU-69553400', 'Sports', 'Opportunity play which sing yourself best reduce nothing. Against case player claim what fact. While stop simply certain boy relationship.
Model couple since appear stand environment meeting. Situation enjoy top right out suggest home. Chance each bad successful seat hard why government.
Hospital make team mention benefit age. Perhaps support field until now send fact.
Establish always history then relationship nor. Couple thought shoulder suggest age you.', 21, 820.13, 75.75, 10, 3.208, False, 2024-08-06 23:00:31);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (269, 'SKU-92318884', 'Non-Fiction', 'Customer early this already despite even spring. Subject push listen most north. By commercial item him herself cultural have.
Special weight itself clear drive much. South like discuss effect. Day science region yourself whole play like. Start single allow toward situation state such.
Because lawyer ball. Inside nor guy. Card hit serve.
Lawyer since project everyone yes. Recent perform air describe wear.', 5, 237.53, 261.73, 6, 46.309, False, 2025-07-06 14:58:30);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (270, 'SKU-8256663', 'Tablets', 'Necessary meeting east. Suffer community adult be national light little.
Popular could value usually central foot. Difficult pattern care campaign those manage late consider. Edge knowledge fund close blood source moment. Cost between understand money it alone.
Most old how she major. Their computer six serve somebody experience former. Reality onto night happy me order language little.', 23, 832.06, 326.92, 8, 13.671, False, 2025-01-21 15:31:52);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (271, 'SKU-86549590', 'Books', 'Professor attention year notice skin democratic increase. Their thank for responsibility. Within one region ask Republican friend.
Director plan which appear. Exactly degree maintain institution husband cultural trip on. Factor whether want there quickly now.
Phone child tend career analysis responsibility but. Best eight mean. Property other house floor focus follow.
Effect old senior amount. Knowledge plan six yard add memory. Require piece good.', 7, 136.97, 770.37, 2, 7.855, True, 2024-09-15 10:25:02);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (272, 'SKU-61288944', 'Toys', 'Let sea ask present ten eight serve dog. War leg push quite marriage.
Tough skin candidate sometimes shoulder. Take follow deal attorney federal positive join.
A tree avoid time physical. Ahead small be produce office along success.
Thought without page marriage protect listen. Least seek color should. Hope matter special site save design.
Hit writer true he certain. For knowledge save here deal role. Wide service second product compare read present.', 15, 466.58, 407.10, 9, 17.979, False, 2025-04-19 01:22:16);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (273, 'SKU-31747213', 'Magazines', 'House team trouble free recently eight oil. On as painting.
Thousand husband your article hour hope. Society approach quickly home. Knowledge left scientist whether.
Stuff may bed scientist hair. Them reach live place provide.
Indeed use lot pick clear soon first see. Key light article guess might once.
Become consider onto painting participant over benefit.
Consumer state long anyone camera easy simply. Deep campaign meeting crime.', 7, 452.46, 463.88, 2, 4.612, True, 2024-08-26 07:12:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (274, 'SKU-96963335', 'Furniture', 'Someone send list project trade from. Choose detail happy third real follow make ago. Crime six character challenge sing require. Up something ground century take money marriage hear.
Sort out improve machine church moment. Sure material include put fly.
To early serve type. Your we rise any. Any music firm science standard walk seek.
Book activity morning board no politics threat. Main man whom effect itself open. Most sign nature interview create himself plant.', 22, 304.91, 704.99, 10, 2.112, False, 2024-11-22 11:25:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (275, 'SKU-27747638', 'Kitchen', 'Each would anyone white boy face floor. Education candidate indicate. Long training nor clearly away green onto late.
Administration mouth scientist first boy news. Seem machine result home half pass. Money model south media other quite total.
Bring both place movement where enough society. Usually ask itself such floor fund economy live. Down policy bag develop ever.
Hard total authority tax per until. Strategy light health or protect summer determine. Sport American single truth.', 11, 149.17, 711.44, 6, 19.873, False, 2024-12-10 08:46:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (276, 'SKU-31775439', 'Clothing', 'Theory crime require partner line usually. Provide after how specific mean room build idea.
Majority major pick plan mean teacher chair.
Let vote easy onto light. Ok spend right test suffer. Agree matter notice material special upon.
Rather factor you product.
Over church particular win. Rather admit kid. Represent ready challenge green large.
Face down forward fight bad goal. Building learn floor once style whatever watch.', 22, 299.54, 820.26, 3, 1.651, False, 2025-02-03 02:50:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (277, 'SKU-19050217', 'Tablets', 'Describe people he show scientist wind glass. System impact indeed consider single. Blood hold drug last agreement use low.
Difference notice sport side born without. Color be list look able though read. Along whatever head democratic impact end TV.
Sing several up interest class movie. From including various little he value.
Large during trial so fact specific. Want serious protect kind too capital. Family condition read.', 15, 556.39, 550.57, 2, 23.156, False, 2025-07-31 09:58:36);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (278, 'SKU-40664631', 'Furniture', 'Bring her mission budget short. Beat play picture wide. Discuss expect relate key. And among stop friend feeling we.
Case phone age them number race unit his. Smile perhaps forward power school system power media. Turn different pretty.
Design fall cell clearly guy side trouble. Machine model determine glass.
End positive the partner. Husband easy parent side role employee.
Trade report adult reduce their right test myself. Many close first feeling reach heavy.', 5, 122.33, 62.61, 4, 6.623, False, 2025-03-01 15:57:41);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (279, 'SKU-39467728', 'Kitchen', 'Board Congress benefit area herself for until his. Hard discuss choice glass. Blue kid order laugh common term.
Until social police walk major hair. Art nor measure situation build tough present. Serve similar behind interest. Common visit step enter traditional.
Because individual already enter she have involve. Why radio matter plan outside.
Experience worry either process stuff sometimes boy despite. Newspaper effect media stock career owner specific. Know order us save fine.', 13, 372.86, 630.66, 2, 29.158, True, 2024-12-06 05:11:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (280, 'SKU-47408620', 'Health', 'Beat culture stage involve check because. Eight but reach general successful offer goal. That pick significant term.
Happy total me. Member event theory two. Just likely character.
Fill realize contain peace major. Safe eat image citizen.
Choice important large trouble involve. Its pass treatment soldier teacher.
Several Mr land relationship sell. Rather wish face parent create authority indicate get. Church term road this important end spring. Travel form identify.', 3, 22.78, 65.41, 8, 40.484, False, 2025-07-12 06:37:54);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (281, 'SKU-97722308', 'Books', 'Administration huge evidence stand church interest Mrs. The develop more really.
Western author government simple property drive. Name behind machine employee beautiful fish sound. Purpose simple activity. Suffer dog herself arrive however week.
Special financial weight need. Car value where bit site year chair when. Which between society each amount indeed.
Morning almost follow lose. Three market prepare house remember this ask nor.', 11, 123.40, 942.33, 1, 8.483, False, 2024-08-08 17:35:48);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (282, 'SKU-26173920', 'Shoes', 'Owner west ago. Game so professor. Huge always account concern. Manage message for president perhaps.
Pattern as collection direction bring form company. Six debate career law quickly who foreign also. Or table eat range suffer.
Side happy doctor be Mr skin guess. Lawyer appear little pick store.
Send describe in out model. Success growth police half admit story from.
Manage although themselves matter let all ok. Break smile believe these soldier.', 14, 821.86, 395.60, 1, 19.198, True, 2024-10-12 20:41:44);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (283, 'SKU-957584', 'Gaming', 'Worry speak himself rather. Back hold everybody set human. Discuss here fall tough well.
Account little reality building. Far let school animal several page PM gun.
Our report accept stop. Including kid speak point church individual. Half hard line it gun.
Dream war change control. Situation heavy yes approach increase score against.
Cold cover third key explain professor oil happen. Marriage court campaign many.', 6, 354.59, 908.39, 5, 14.065, True, 2025-07-12 04:45:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (284, 'SKU-40983865', 'Garden Tools', 'Describe trip very kitchen type like. Begin through a important others. Toward fish apply goal science.
Effect throughout power some value.
Left hit deal theory. Billion call degree develop. Professor mission stock because.
Visit who like. Group stuff employee air now program.
Talk sit reveal report their. Star chance fact but thank day several. Field produce would attorney.
These list there probably wall. Ever send certainly director.', 5, 35.61, 619.55, 4, 32.399, True, 2025-04-02 15:25:30);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (285, 'SKU-94179677', 'Men''s Clothing', 'Chance everything ready hospital chair suddenly manager interesting. Could understand better item term oil. Act almost food start billion real.
Woman up bit difference purpose political sea. Plan series activity many out.
Movement office range fly security apply newspaper.
Worker ever receive follow teach. Police major study drive environment. He pressure president participant eat.', 14, 882.89, 479.55, 2, 14.061, False, 2025-08-01 02:25:24);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (286, 'SKU-47554476', 'Sports', 'Glass TV check attack environment role hospital measure.
Scientist paper play commercial baby. Bed get especially speech. Concern maintain position throughout ago with.
Maybe cut several change property brother.
Owner there chance step civil drop. Control hope marriage get. Mind general series investment interesting. Record when end country social market remain.
Cut practice discussion majority. Conference six put finally character.', 14, 200.26, 884.76, 9, 12.532, True, 2025-01-02 08:03:59);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (287, 'SKU-39645688', 'Furniture', 'Decision one law development return between which. Camera chance dream billion.
Pretty anything ahead foreign health. Concern employee window.
Strategy speech represent theory color cause role. Direction color almost machine.
Sell though team listen wait series rest. Debate store bit lose worker.
There when day peace buy wear born. Control heart approach according yet other land. Blood discussion understand successful feeling research.', 18, 795.04, 989.40, 6, 24.036, True, 2024-08-07 19:27:22);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (288, 'SKU-43066848', 'Furniture', 'Focus wall million take true necessary. Project single agree new.
Present discussion yeah around us role movement. Loss wish shake which middle save despite.
International far fly sure water describe. Land administration in.
Popular production husband she. Bed of would responsibility recent. Writer opportunity front detail.
Majority risk subject eight arm. Manage baby letter similar Democrat occur present. Increase specific oil. To expert try.', 16, 344.69, 566.08, 6, 19.480, False, 2025-04-15 07:48:29);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (289, 'SKU-81323134', 'Toys', 'Respond despite southern vote person build.
Worry trade security alone generation nature product.
Suggest finish wish. Action without better page soon whose. Much song various enjoy focus force. Your season rest sister station language family.
Wide employee unit. Tough wind TV type program information.
Nor company bring. Position sometimes over others drug under.
Difference election physical field.
Scene much hold long number successful.', 1, 319.56, 219.80, 5, 3.024, True, 2025-03-31 20:08:43);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (290, 'SKU-62003491', 'Men''s Clothing', 'Social fast whose special go guess affect. Ok center example interesting first instead bar. Morning recent own school become.
Color throughout society himself. Race health news brother. Form against drive full again test upon.
Either place raise loss sound task wife. There stand strategy big always while.
Red business learn line. Gun white between member.
Here information half way measure. Edge final walk my.
Thus attack because sometimes drug know camera. Should value other report sit.', 17, 358.07, 584.40, 4, 48.702, True, 2025-03-07 09:41:11);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (291, 'SKU-99515838', 'Home & Garden', 'Nice popular live during however police south. Sort table like day most focus. Task go none talk lawyer.
Suggest occur fill itself. It reason hundred arm particular open over. Clear stuff call officer possible decision.
Ten many up administration soldier inside. Five bring pick suffer job skill someone. Present station indeed another field everyone knowledge whole.
Alone source suffer life understand. Wide you seek recent.', 8, 657.20, 267.26, 1, 38.226, False, 2025-02-01 15:14:56);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (292, 'SKU-52395415', 'Automotive', 'Drug full even contain remember. Ago north game democratic act last. Up like month religious simple little occur.
Marriage water new yard success tell save. Stage age important interest particular all. Sing itself themselves enough.
While sound experience reality animal whether owner huge. It difference many sit.
Cause make information explain yet. Born cover quite old against student likely community. Compare already hold available interview live artist person.', 19, 846.65, 797.59, 6, 46.767, True, 2024-10-09 20:31:43);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (293, 'SKU-58008368', 'Bathroom', 'Serious everything example need. Recent pull police traditional. Brother population company suggest inside enjoy easy yard.
Network year town enjoy. Opportunity benefit bank certain special step. Sport see arrive happen weight worker quite.
Child off until still newspaper. Return ground technology second young. Morning feel drug rest. Fill near sing approach during.
Little carry society yet offer sport husband. Another success good citizen kitchen paper.', 6, 176.92, 592.92, 6, 45.708, True, 2025-07-02 00:21:22);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (294, 'SKU-79794211', 'Electronics', 'Talk whose kind media. Either small himself pattern appear adult here.
Help per some finish strong example season magazine. Program anyone adult after.
Least bill attorney. Simply evidence skill eat argue unit institution just.
Per develop group air old. Decade as bag think rest memory.
Kitchen different themselves spend local reason. Would realize every course. Growth week soon your according want relationship.', 23, 700.85, 947.60, 10, 7.191, True, 2025-07-24 19:42:33);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (295, 'SKU-21379741', 'Beauty', 'Work indeed decade. Free suffer order unit apply trip.
Wish establish game return. Stock base stop represent all. Whatever fund bar.
Two remain occur foreign whom. Image store character image sister sometimes reflect ever. You parent individual suggest either maybe through.
First glass study college. Husband end arm opportunity enjoy. Increase body rock man table they school.
Since body break no still best area. Again away material size form treat among.', 16, 542.58, 176.38, 1, 4.604, True, 2025-05-26 04:11:08);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (296, 'SKU-19454935', 'Automotive', 'Social affect much record summer ask standard. Just memory indeed side computer. Edge pay yes amount central artist rise.
Far them until knowledge. Process bad president analysis movement top. International officer child use other.
In bit another edge tend situation. Also someone it bag story lead. Report Mr accept tonight.
Economy medical wind guy join morning into. Lot animal into capital begin risk sometimes. Network discussion only bring.', 20, 219.59, 526.92, 1, 16.654, False, 2025-07-21 19:29:55);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (297, 'SKU-37633060', 'Accessories', 'Question bill reach and or space space.
There hospital same mouth team ahead computer similar. Sense something article democratic benefit address. Music chance make probably society sure themselves.
Same huge drive. Difficult he front goal.
Fish hot together send. Relate charge occur then why must. Type second history would car growth. Message could certain art challenge for.
Animal near war after pass adult. Next use standard state town television.', 7, 806.63, 341.41, 3, 45.947, False, 2024-10-30 16:00:34);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (298, 'SKU-3666881', 'Bathroom', 'Issue different speech student research.
Participant system pick thought himself north support.
Health someone expect level particular anything store. Section start around like call pressure.
Civil lay enjoy. Young above want answer. Somebody today brother perhaps until foreign make federal.
Meet a executive machine agency civil clearly. Six know general difference actually really.
Authority success together bring forget education. Begin just member public. Add guess decade tend second build.', 11, 60.50, 148.56, 3, 38.741, False, 2025-03-15 05:17:12);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (299, 'SKU-81028224', 'Bathroom', 'Soon child imagine person six. No throw on large memory study.
Note character hard. Owner heart anything include in.
Ball feeling spend but local particular.
Beautiful population movement sport nothing throw hope expert. Issue debate into question crime.
Realize other society health inside set. All myself floor board family red.
Language nearly look improve direction wish service. Cup example special decision.
Modern serve billion now about certain agree. Many else agency financial.', 17, 860.80, 960.59, 6, 35.256, False, 2024-08-24 06:21:51);
INSERT INTO products (id, sku, name, description, category_id, price, cost, stock_quantity, weight, is_active, created_at) VALUES (300, 'SKU-74457740', 'Non-Fiction', 'Cut third amount leave. Participant year my far. Anyone reach gun model two catch about.
Then prevent top style identify month world community. These name off action. Simple together table mean traditional as.
Onto find tend hard name entire follow. Institution simply quality.
Church experience program participant. Year kitchen describe among artist deep next. Pay trial generation. Either most lay of want.
East effort tonight five help reality trouble. Hit consumer describe prove.', 13, 586.42, 337.22, 6, 6.909, True, 2025-01-21 15:46:25);


-- Table: reviews
-- ================================================

DROP TABLE IF EXISTS reviews CASCADE;

CREATE TABLE reviews (
    id INTEGER NOT NULL DEFAULT nextval('reviews_id_seq'::regclass),
    product_id INTEGER,
    user_id INTEGER,
    rating INTEGER,
    review_text TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);



-- Table: users
-- ================================================

DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    instance_id UUID,
    id INTEGER NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    id UUID NOT NULL,
    username CHARACTER VARYING,
    aud CHARACTER VARYING,
    email CHARACTER VARYING,
    role CHARACTER VARYING,
    full_name CHARACTER VARYING,
    email CHARACTER VARYING,
    phone CHARACTER VARYING,
    encrypted_password CHARACTER VARYING,
    birth_date DATE,
    registration_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    email_confirmed_at TIMESTAMP WITH TIME ZONE,
    invited_at TIMESTAMP WITH TIME ZONE,
    status CHARACTER VARYING DEFAULT 'active'::character varying,
    total_spent NUMERIC DEFAULT 0,
    confirmation_token CHARACTER VARYING,
    confirmation_sent_at TIMESTAMP WITH TIME ZONE,
    recovery_token CHARACTER VARYING,
    recovery_sent_at TIMESTAMP WITH TIME ZONE,
    email_change_token_new CHARACTER VARYING,
    email_change CHARACTER VARYING,
    email_change_sent_at TIMESTAMP WITH TIME ZONE,
    last_sign_in_at TIMESTAMP WITH TIME ZONE,
    raw_app_meta_data JSONB,
    raw_user_meta_data JSONB,
    is_super_admin BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    phone TEXT DEFAULT NULL::character varying,
    phone_confirmed_at TIMESTAMP WITH TIME ZONE,
    phone_change TEXT DEFAULT ''::character varying,
    phone_change_token CHARACTER VARYING DEFAULT ''::character varying,
    phone_change_sent_at TIMESTAMP WITH TIME ZONE,
    confirmed_at TIMESTAMP WITH TIME ZONE,
    email_change_token_current CHARACTER VARYING DEFAULT ''::character varying,
    email_change_confirm_status SMALLINT DEFAULT 0,
    banned_until TIMESTAMP WITH TIME ZONE,
    reauthentication_token CHARACTER VARYING DEFAULT ''::character varying,
    reauthentication_sent_at TIMESTAMP WITH TIME ZONE,
    is_sso_user BOOLEAN NOT NULL DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE,
    is_anonymous BOOLEAN NOT NULL DEFAULT false
);

-- Data for table users (150 records)
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (1, 'ashley81', 'sydneyfloyd@example.org', 'Sharon Martinez DVM', '825.836.7294', 2024-07-18, 2024-08-31 02:42:34, 'suspended', 1231.61);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (2, 'powellkara', 'shawn75@example.net', 'Raymond Oconnor', '001-775-418-6363x745', 2024-10-14, 2025-06-28 20:00:04, 'inactive', 1903.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (3, 'rkramer', 'williamsconnie@example.com', 'Timothy Moore', '706.432.4241x541', 2023-09-11, 2025-01-02 17:01:05, 'suspended', 3443.93);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (4, 'jessica36', 'padillaaaron@example.com', 'Kevin Stone', '300.351.6271x361', 2024-04-01, 2024-12-22 12:46:12, 'active', 3426.23);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (5, 'derrick22', 'morenoalan@example.net', 'Gregory Lewis', '001-826-797-3112x196', 2025-04-07, 2024-09-25 02:09:31, 'active', 1152.95);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (6, 'joshuamiller', 'kimberly04@example.org', 'Katrina Adkins', '703-476-1379x1805', 2024-05-28, 2025-07-02 02:12:53, 'active', 4027.18);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (7, 'rdiaz', 'kathrynbest@example.org', 'Austin Baker', '3064848666', 2024-03-04, 2024-09-03 06:01:41, 'inactive', 1346.03);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (8, 'christian32', 'peter14@example.net', 'Troy Allen', '416.317.9904', 2023-08-11, 2025-05-03 16:57:31, 'active', 4566.55);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (9, 'jacquelinemartin', 'alexandra42@example.com', 'Richard Adams', '305-964-8149', 2024-07-20, 2025-02-16 03:40:44, 'suspended', 4383.07);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (10, 'brian92', 'eric19@example.net', 'Crystal Hicks', '2038075622', 2024-01-23, 2024-12-04 18:15:32, 'inactive', 1071.01);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (11, 'robertcortez', 'margaret95@example.org', 'Stephanie White', '606.617.4451x87053', 2025-02-26, 2025-03-31 14:59:41, 'inactive', 1984.20);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (12, 'stevenvargas', 'xcuevas@example.org', 'Kimberly Flynn', '(206)803-8505', 2025-05-22, 2025-05-15 10:16:33, 'suspended', 2299.67);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (13, 'dalton83', 'dvasquez@example.org', 'Anna Morse', '865.471.9182x61990', 2024-02-01, 2024-11-23 01:27:52, 'inactive', 706.76);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (14, 'melissa65', 'shawn31@example.org', 'Randy Rodriguez', '527-975-6185', 2024-03-28, 2025-01-28 17:33:00, 'suspended', 2811.23);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (15, 'melissa12', 'margaret90@example.org', 'Erin Davis', '856.980.4420', 2024-10-06, 2025-05-19 07:26:36, 'inactive', 3737.60);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (16, 'codygarcia', 'davidbrown@example.org', 'Rodney Watson', '+1-319-294-1013x7215', 2024-07-25, 2024-08-21 10:49:28, 'inactive', 4490.14);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (17, 'sandrahamilton', 'ycrawford@example.net', 'Hector Odonnell', '947-220-9993x476', 2023-10-09, 2024-11-18 10:32:53, 'inactive', 1816.36);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (18, 'mtaylor', 'crystalpham@example.org', 'Rachael Howard DDS', '659.285.6420x5930', 2025-04-21, 2025-01-31 23:15:50, 'active', 2552.54);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (19, 'katie32', 'wrightjohn@example.net', 'Sylvia Brown', '796.252.2395', 2025-01-29, 2025-04-30 20:32:48, 'active', 3781.35);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (20, 'stacey92', 'marycochran@example.com', 'Casey Johnson', '5394308705', 2024-04-22, 2025-05-07 05:11:24, 'active', 772.68);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (21, 'samantharichard', 'brian29@example.net', 'Patricia Mathis', '(915)769-1545x226', 2023-12-15, 2025-05-03 10:16:10, 'active', 3962.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (22, 'jeffrey92', 'sparker@example.com', 'Nicholas Rush', '001-369-902-9593', 2023-11-19, 2024-12-08 09:33:37, 'inactive', 2986.08);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (23, 'youngtoni', 'daisymccarty@example.net', 'Monica Rogers', '2438315410', 2024-07-07, 2025-05-13 07:01:45, 'inactive', 1914.28);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (24, 'acosta', 'wmacias@example.net', 'Ronald Kramer', '001-632-371-0405', 2023-09-28, 2024-12-12 12:43:49, 'inactive', 2650.28);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (25, 'pamelamartin', 'paynerachael@example.org', 'William Barry', '001-806-629-6201x533', 2024-12-27, 2024-11-19 02:49:55, 'suspended', 4305.29);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (26, 'john06', 'xhernandez@example.org', 'Edward Stanley', '+1-873-910-3241x714', 2024-08-15, 2025-07-15 07:42:34, 'active', 3404.61);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (27, 'christopher86', 'nathanjames@example.org', 'Dennis Marshall', '849.502.1158', 2024-10-04, 2024-08-25 11:15:23, 'active', 3411.73);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (28, 'acardenas', 'parmstrong@example.com', 'James Nash', '4894899217', 2024-01-13, 2025-06-11 18:14:49, 'suspended', 3756.88);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (29, 'davidhenderson', 'oharris@example.org', 'Deanna Bartlett', '916-286-8548', 2025-04-03, 2025-04-30 19:09:39, 'suspended', 1707.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (30, 'jrodriguez', 'ashleyaguilar@example.org', 'Kristine Garcia', '885-464-6799x7024', 2024-11-24, 2025-03-26 03:55:30, 'inactive', 2179.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (31, 'vwilliams', 'brandonalvarez@example.com', 'Alicia Roth', '344-571-3247x5469', 2024-07-10, 2024-10-22 21:08:57, 'inactive', 26.19);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (32, 'wfigueroa', 'lori82@example.org', 'Jonathon Taylor', '790.923.3030x70534', 2024-08-28, 2025-01-02 22:37:01, 'suspended', 4380.51);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (33, 'maldonadojohn', 'lwheeler@example.com', 'Hannah Martin', '614-806-0293x333', 2024-09-03, 2024-08-09 13:44:54, 'inactive', 4859.72);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (34, 'wellsdavid', 'carolynsmith@example.com', 'Terri Marquez', '001-846-365-7437x489', 2023-08-07, 2025-02-16 10:30:01, 'active', 2543.33);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (35, 'anna99', 'kenneth17@example.org', 'Donald Nguyen', '244-932-8309x652', 2024-03-18, 2024-11-10 12:52:30, 'active', 4353.89);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (36, 'vsullivan', 'aguilarwanda@example.org', 'Micheal Parks', '+1-475-784-2824x1724', 2024-12-22, 2024-09-05 11:10:53, 'inactive', 4209.93);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (37, 'michaelgarner', 'robert55@example.com', 'Julie Wilson', '8996917381', 2024-06-17, 2024-08-22 18:44:27, 'suspended', 3048.76);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (38, 'derrickgonzalez', 'dbenitez@example.org', 'Mike Maxwell', '352.450.0743x2927', 2024-11-21, 2025-01-17 05:19:49, 'active', 1875.83);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (39, 'epowell', 'ismith@example.org', 'Tiffany Mcclain', '001-683-400-3354x216', 2023-09-21, 2025-06-17 17:37:40, 'active', 2701.50);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (40, 'evanskelly', 'ryan25@example.com', 'Colin Vaughan', '(803)632-3098x2150', 2025-03-23, 2025-02-25 10:55:25, 'suspended', 4593.28);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (41, 'wheelerbrandon', 'valdezandrew@example.net', 'Jeremy Martinez', '472-830-4618x499', 2025-05-08, 2025-07-16 18:36:37, 'suspended', 1627.54);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (42, 'huntchristine', 'daniel17@example.org', 'Paula Decker', '956.742.0873', 2024-01-31, 2024-08-02 20:22:01, 'active', 568.22);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (43, 'powersrebecca', 'fhernandez@example.net', 'Nathaniel Conway', '+1-837-344-7012x0455', 2023-10-14, 2025-06-28 09:02:01, 'inactive', 4394.82);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (44, 'smithdevon', 'markkline@example.net', 'Nicholas Watson', '421-366-7467x62120', 2024-06-20, 2025-07-21 16:05:45, 'inactive', 1204.87);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (45, 'rpham', 'ywhite@example.com', 'Shari Hobbs', '001-527-771-6701x450', 2024-09-08, 2025-02-20 22:31:18, 'active', 4391.27);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (46, 'reynoldsjessica', 'rreed@example.net', 'Ryan Grant', '+1-700-628-7721x753', 2023-09-10, 2025-02-14 15:46:14, 'active', 437.41);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (47, 'andreagray', 'christianwallace@example.net', 'Scott West', '270-316-6088', 2025-04-07, 2025-03-24 10:25:46, 'inactive', 4081.96);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (48, 'pamela83', 'xclements@example.org', 'Sarah Rivera', '001-799-375-7113x055', 2023-09-06, 2025-07-16 02:20:51, 'suspended', 3831.51);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (49, 'travisunderwood', 'nrodriguez@example.org', 'Timothy Long', '435.916.0917x798', 2023-08-05, 2025-02-23 18:12:03, 'active', 3302.16);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (50, 'tranryan', 'xglass@example.org', 'Carrie Ochoa', '569-695-8669', 2024-06-06, 2024-12-12 22:31:21, 'suspended', 833.98);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (51, 'shawn22', 'vmorrison@example.net', 'Michael Valencia', '001-783-333-9452x288', 2025-03-14, 2024-12-16 13:56:28, 'suspended', 4363.44);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (52, 'qaguilar', 'icraig@example.com', 'Jenny Smith', '606-620-0342', 2023-11-23, 2025-06-23 18:27:09, 'inactive', 4822.17);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (53, 'vaughnkenneth', 'howardshaun@example.net', 'Nancy Hancock', '001-286-638-4066x658', 2024-01-06, 2025-03-30 18:54:04, 'suspended', 3778.77);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (54, 'ogreer', 'kari89@example.org', 'Tracey Phillips', '(612)628-1606', 2023-11-11, 2024-10-03 06:48:45, 'suspended', 1013.74);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (55, 'adam72', 'hernandezmarcus@example.org', 'Lori Cameron', '479-885-1583x2818', 2024-09-26, 2025-02-26 08:23:05, 'inactive', 2000.97);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (56, 'odavis', 'elizabethrivera@example.com', 'Paul Moreno', '+1-201-757-3993', 2024-05-24, 2025-07-23 11:57:21, 'suspended', 3252.89);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (57, 'cruzamber', 'angel85@example.net', 'Jill Williams', '+1-835-381-1288x0133', 2024-01-08, 2025-02-26 15:04:46, 'inactive', 4499.07);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (58, 'elucas', 'andrewlove@example.org', 'Anthony Bauer', '+1-819-734-6676', 2023-08-15, 2024-12-31 01:16:02, 'inactive', 613.81);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (59, 'nicholsdarlene', 'avilabrenda@example.net', 'Heather Shaw', '449-814-7660x7283', 2025-04-11, 2025-06-07 11:56:32, 'active', 329.49);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (60, 'susan24', 'susan08@example.net', 'Andrew Armstrong', '(588)614-3536x8222', 2023-12-30, 2024-09-15 07:12:23, 'active', 2945.66);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (61, 'emilybradley', 'yorksarah@example.net', 'Joshua Roberts', '541-339-7552', 2024-03-10, 2025-03-30 09:09:09, 'active', 2946.32);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (62, 'mcculloughlouis', 'qmurphy@example.com', 'Brittany Knight', '962-705-3364x52577', 2025-03-25, 2024-11-28 10:03:01, 'active', 364.26);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (63, 'larnold', 'wilkinsonmichele@example.org', 'Christina Gross', '+1-611-908-0996x9308', 2024-12-21, 2025-05-29 20:12:32, 'suspended', 303.78);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (64, 'michaelwalker', 'dennis88@example.org', 'Jonathan Bates', '+1-228-527-2299x275', 2025-03-15, 2025-02-07 04:00:04, 'active', 4528.05);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (65, 'bryanwood', 'barnettapril@example.com', 'Thomas Keith', '4518844989', 2024-12-21, 2024-12-26 18:53:42, 'inactive', 363.58);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (66, 'briana18', 'nicholas38@example.com', 'Sean Tucker', '490.482.7231x8432', 2024-05-09, 2025-03-23 14:04:57, 'active', 1399.60);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (67, 'guerrerorobert', 'jennifer77@example.com', 'Christopher Whitaker', '2304299228', 2023-09-14, 2024-10-05 09:15:39, 'inactive', 1079.04);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (68, 'sandra86', 'johnsjessica@example.com', 'Claire Obrien', '772.936.9292x9842', 2024-11-07, 2025-03-19 03:36:02, 'active', 3619.53);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (69, 'hallpaul', 'smithalexandra@example.net', 'Samantha Jacobs', '(979)490-8811', 2025-07-02, 2025-03-24 03:38:18, 'suspended', 2885.30);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (70, 'princekimberly', 'xboyd@example.org', 'Jessica Mays', '865.699.1624x7314', 2023-12-26, 2024-08-03 21:49:33, 'active', 3925.25);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (71, 'lanedavid', 'brooksjamie@example.com', 'Brian Simmons', '001-844-586-9594', 2024-06-17, 2025-03-04 04:50:16, 'inactive', 960.15);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (72, 'jwhite', 'tking@example.net', 'Michael Fitzgerald', '+1-813-272-1386x5890', 2025-04-17, 2024-09-06 03:51:14, 'active', 3298.32);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (73, 'thomasburke', 'brownjeffrey@example.org', 'Misty Arias', '(598)249-0277x0384', 2025-04-01, 2025-03-22 14:43:51, 'inactive', 2123.66);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (74, 'christinacraig', 'john02@example.org', 'Penny Gomez MD', '001-738-701-1848', 2025-04-26, 2024-11-17 04:05:12, 'inactive', 4320.55);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (75, 'catherinelee', 'qandrews@example.org', 'Brian Jones', '751-984-8947x6973', 2025-01-12, 2025-01-27 17:04:21, 'active', 3370.09);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (76, 'olsonjonathan', 'oschultz@example.net', 'Rebecca Gutierrez', '(488)904-3416x518', 2024-04-01, 2024-12-17 02:03:33, 'suspended', 501.11);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (77, 'patriciaadams', 'victorgonzalez@example.net', 'Derek Perez', '295.221.1179', 2025-05-21, 2025-02-05 02:08:05, 'inactive', 3643.79);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (78, 'christine79', 'travis84@example.com', 'Kenneth Brown', '(278)508-5627x18750', 2024-05-22, 2025-03-15 10:14:09, 'active', 1250.80);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (79, 'nguyenchloe', 'jacob43@example.com', 'Louis Diaz', '563.365.5647x2929', 2025-02-11, 2024-11-14 14:57:17, 'active', 2686.07);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (80, 'angelachase', 'dustinhaley@example.org', 'Adam Fisher', '(288)857-4489', 2023-10-17, 2025-04-26 23:10:33, 'active', 2115.19);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (81, 'briancervantes', 'gcombs@example.com', 'Debbie Ward', '+1-445-606-1593', 2024-05-03, 2024-12-06 00:54:28, 'inactive', 2318.51);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (82, 'champton', 'jamesjustin@example.net', 'Sheena Davidson', '869-696-1125x35544', 2025-06-21, 2025-01-21 13:36:01, 'active', 2221.22);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (83, 'julie87', 'bjackson@example.org', 'Mary Shepard', '001-813-326-1117x800', 2023-10-21, 2024-11-11 17:04:45, 'suspended', 498.56);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (84, 'christopherhuynh', 'pparker@example.net', 'Mark Anderson', '(900)455-7784', 2025-01-24, 2025-02-27 05:22:17, 'suspended', 4996.42);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (85, 'brittanybryant', 'omills@example.net', 'Gregory Fernandez', '274-456-4240', 2024-04-25, 2024-11-21 03:39:53, 'active', 4845.29);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (86, 'snichols', 'earroyo@example.com', 'Jeffrey Carter', '508.453.6866', 2025-02-07, 2025-05-15 01:16:59, 'active', 839.89);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (87, 'oclayton', 'christian38@example.net', 'Melinda Mitchell', '001-684-963-1224x179', 2023-12-25, 2024-12-04 07:27:47, 'inactive', 2411.98);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (88, 'hernandeztara', 'lopezcurtis@example.com', 'Jeffrey Smith', '720-973-5647', 2025-01-24, 2025-06-05 03:27:35, 'inactive', 4513.19);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (89, 'riveramegan', 'brianrowe@example.org', 'Catherine Huang', '560-913-6730x371', 2024-05-30, 2025-04-23 10:20:58, 'active', 1901.08);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (90, 'sharon20', 'kingdanielle@example.org', 'Anthony Estrada', '836-550-2491', 2023-08-08, 2024-08-18 02:15:12, 'inactive', 1333.36);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (91, 'jbarker', 'kelli32@example.com', 'Luke Galvan', '001-500-252-8127x358', 2025-01-18, 2024-12-26 11:54:31, 'inactive', 1433.39);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (92, 'jennifer40', 'jmann@example.com', 'Katherine Knight', '+1-455-974-9821', 2024-03-18, 2025-06-16 00:22:53, 'suspended', 4787.02);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (93, 'amber70', 'bgross@example.net', 'Patty Allen', '001-718-363-8782x945', 2023-10-15, 2025-02-20 23:25:45, 'suspended', 3312.74);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (94, 'williamssharon', 'morganharris@example.com', 'Andres May', '(978)399-4053x9103', 2024-07-30, 2025-06-08 20:53:38, 'inactive', 782.44);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (95, 'wardjulia', 'yshort@example.net', 'Luis Rice', '001-514-413-8113x863', 2024-10-08, 2025-05-19 17:50:40, 'inactive', 1096.33);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (96, 'xreese', 'emily61@example.org', 'Krista Wagner', '+1-528-597-5585x5665', 2024-05-19, 2025-05-26 03:45:53, 'active', 2900.11);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (97, 'michael77', 'csmith@example.com', 'Kelly Holder', '404-333-5048x8899', 2023-08-31, 2025-01-27 13:48:16, 'suspended', 314.18);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (98, 'eric45', 'jesseshepherd@example.org', 'Laura Robinson', '257-827-9194', 2023-10-01, 2025-05-31 18:06:36, 'inactive', 295.25);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (99, 'weeksmatthew', 'hbutler@example.org', 'Sarah Mcfarland', '+1-460-248-0589x2583', 2025-01-06, 2025-05-12 21:39:12, 'suspended', 2389.17);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (100, 'wmaddox', 'walkerkeith@example.com', 'George Alvarez', '001-508-964-1686x227', 2024-06-04, 2025-04-12 02:14:34, 'suspended', 795.59);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (101, 'annshea', 'johnadams@example.com', 'Thomas Davis', '+1-966-455-3559x0425', 2024-07-09, 2024-08-19 05:08:09, 'suspended', 409.76);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (102, 'jamesbrooks', 'rodriguezbrian@example.net', 'Sheila Wilkins', '5515477053', 2024-09-29, 2025-02-21 00:02:18, 'active', 351.92);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (103, 'ana92', 'bennettrebecca@example.net', 'Christopher Campbell', '001-694-807-0164x510', 2024-01-28, 2024-12-27 15:14:21, 'active', 3379.31);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (104, 'mckeetodd', 'lopezvincent@example.com', 'Michelle Williams', '245.676.2055x54384', 2025-06-14, 2024-12-30 03:32:18, 'active', 2024.84);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (105, 'raymondstacy', 'edwardprince@example.net', 'Nicholas Meyer', '+1-593-463-9264x9578', 2024-10-26, 2025-02-28 00:37:49, 'suspended', 1238.61);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (106, 'michelleparker', 'russellstout@example.org', 'Krystal Moore', '888-812-5205', 2024-03-24, 2025-01-20 19:56:52, 'suspended', 208.31);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (107, 'edwin31', 'jackfarmer@example.net', 'Lisa Salazar', '+1-433-805-1728x975', 2024-08-17, 2025-02-01 19:25:13, 'active', 2101.93);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (108, 'frankperez', 'aduran@example.com', 'Courtney Powers', '531.827.9757', 2024-06-11, 2025-05-30 05:41:33, 'suspended', 2830.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (109, 'franklinmadison', 'phillip99@example.net', 'Sheri Buchanan', '517.670.3886x08680', 2024-07-08, 2025-01-03 08:50:51, 'inactive', 4674.18);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (110, 'kim47', 'robertoaustin@example.org', 'Stephanie Ford', '+1-271-481-2982x6657', 2024-07-19, 2025-03-19 00:59:09, 'active', 3351.93);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (111, 'nicoledavis', 'heather21@example.org', 'Jerry Cox', '468.492.6860x25922', 2025-03-21, 2025-05-05 07:36:38, 'inactive', 1201.04);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (112, 'barneskyle', 'lroberts@example.org', 'Toni Smith', '001-940-877-7809x733', 2024-07-10, 2024-09-01 14:57:15, 'inactive', 663.08);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (113, 'sanchezamy', 'brandonhernandez@example.net', 'Charles Johnson', '001-494-651-0162', 2024-11-18, 2025-04-15 11:06:38, 'suspended', 1506.99);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (114, 'tammycurry', 'sarah14@example.com', 'James Jones', '(281)347-2145x86833', 2024-10-18, 2025-05-12 04:24:34, 'inactive', 4645.80);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (115, 'webbhaley', 'ronald54@example.net', 'Lisa Ho', '+1-397-287-7293x430', 2024-07-28, 2025-04-01 16:33:48, 'active', 56.48);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (116, 'mclaughlinjared', 'vgutierrez@example.com', 'Marcia Smith', '244.314.4885', 2025-01-15, 2024-12-09 05:16:07, 'suspended', 4992.29);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (117, 'randy99', 'collierjames@example.com', 'Karen Wells', '2276278576', 2024-10-13, 2025-05-10 08:00:09, 'active', 375.57);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (118, 'angela03', 'lauren51@example.org', 'Andre Terrell', '+1-882-399-6291x4504', 2024-08-22, 2025-07-08 09:32:01, 'active', 2534.36);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (119, 'nathangallegos', 'javier42@example.org', 'Andrew Harris', '978-607-8235', 2025-03-26, 2024-12-06 21:51:28, 'active', 4666.96);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (120, 'kaylagarcia', 'jamiejohnson@example.com', 'Kelly Smith', '2916570184', 2024-12-10, 2025-07-14 06:09:11, 'active', 4397.56);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (121, 'manuellee', 'amanda71@example.com', 'Donald Smith', '+1-588-413-8585x424', 2023-09-26, 2024-11-30 17:05:46, 'inactive', 1432.09);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (122, 'amber02', 'ruizemma@example.org', 'Brandon Myers', '001-499-379-5453x817', 2025-04-24, 2025-06-09 09:17:44, 'inactive', 4170.39);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (123, 'tdavis', 'oruiz@example.org', 'Lisa Durham', '(425)657-7017x1577', 2025-03-20, 2024-12-15 04:10:42, 'suspended', 1519.56);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (124, 'williamsullivan', 'nguyendebra@example.com', 'Jennifer Gutierrez', '+1-738-527-6153x966', 2023-12-14, 2025-04-16 02:50:26, 'suspended', 2649.41);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (125, 'stevensonjennifer', 'mwilson@example.com', 'Brent Wallace', '261-491-9657x0132', 2024-12-27, 2024-09-28 17:38:41, 'suspended', 4087.35);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (126, 'yschmidt', 'rgonzalez@example.com', 'Robert Frazier', '(251)790-9862x40580', 2023-10-26, 2025-07-02 06:15:31, 'inactive', 4659.46);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (127, 'michelle36', 'tgarrett@example.com', 'Jeffrey Clark', '(672)438-6562', 2023-11-14, 2024-08-06 06:59:32, 'active', 4695.26);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (128, 'wongdouglas', 'ibarrett@example.org', 'Robert Dalton', '001-596-492-7868x765', 2024-06-26, 2025-03-24 13:52:41, 'active', 1329.68);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (129, 'lanemelanie', 'jenniferadams@example.net', 'Amanda Johnson', '351.597.1284x7818', 2024-08-02, 2025-04-03 17:03:02, 'active', 3714.66);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (130, 'suttonamber', 'chloe58@example.org', 'Jose Harrison', '001-956-454-4209x494', 2024-10-19, 2024-08-21 19:58:44, 'active', 1369.02);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (131, 'lisa90', 'todd28@example.org', 'Diana Anderson', '644-501-9292x752', 2024-08-12, 2024-10-11 00:06:38, 'suspended', 1061.04);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (132, 'cooperchristopher', 'caitlinunderwood@example.com', 'Jennifer Reyes', '+1-672-939-5041x0276', 2025-03-03, 2025-05-20 23:58:58, 'inactive', 1025.95);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (133, 'noahthornton', 'hbaker@example.com', 'Timothy Cole', '+1-658-801-8569x4544', 2024-07-25, 2025-05-29 01:08:12, 'suspended', 4266.03);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (134, 'jessicachapman', 'aprilbyrd@example.org', 'Adam Smith', '606-618-1753', 2023-12-29, 2024-08-15 00:08:21, 'suspended', 2447.77);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (135, 'harveybrian', 'stephanielittle@example.net', 'Angelica Jacobs', '(692)412-4471x7465', 2025-03-30, 2024-08-30 12:32:58, 'active', 470.57);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (136, 'kimberly66', 'wendy44@example.org', 'John Mcfarland', '+1-662-371-2863x917', 2023-08-29, 2024-08-30 02:30:21, 'inactive', 4148.45);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (137, 'duncanjohn', 'fsmith@example.org', 'April Johnson', '(542)256-9087x7661', 2024-05-26, 2025-04-26 11:13:40, 'active', 27.69);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (138, 'imartinez', 'mathew46@example.org', 'Tina Davis', '+1-851-574-3280', 2024-03-21, 2025-04-29 00:56:23, 'active', 3189.20);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (139, 'omosley', 'tom73@example.org', 'Alexander Davies', '276.218.4787', 2024-04-21, 2024-08-23 13:18:44, 'inactive', 816.29);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (140, 'kristin06', 'lewisdesiree@example.net', 'Michael Sawyer', '(293)510-2707', 2025-01-27, 2025-04-10 17:58:28, 'inactive', 2762.89);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (141, 'alexischen', 'lori17@example.net', 'Kevin Meyers', '717-899-3136', 2024-04-09, 2024-09-17 16:48:26, 'inactive', 2808.93);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (142, 'marcoconnell', 'kathrynwatkins@example.com', 'Donald Todd', '(358)827-3902', 2025-03-28, 2024-10-02 01:13:03, 'active', 385.47);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (143, 'hobbschristopher', 'whitechristopher@example.net', 'Diane Steele', '001-472-932-4876x329', 2024-11-19, 2024-09-04 23:15:50, 'suspended', 4520.60);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (144, 'michael08', 'jamesdowns@example.org', 'Shari Hatfield', '237.734.0312x77220', 2024-03-10, 2024-10-22 04:21:54, 'suspended', 189.78);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (145, 'nking', 'vwilliams@example.org', 'Casey Floyd', '381.713.7995x6353', 2024-01-25, 2024-09-08 20:52:15, 'inactive', 2916.72);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (146, 'joankane', 'evance@example.com', 'Amy Graham', '797.626.5273', 2024-01-06, 2024-12-10 05:34:52, 'active', 2154.64);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (147, 'antoniocarroll', 'derek77@example.com', 'Greg Tanner', '+1-929-929-8316x873', 2024-03-05, 2024-08-07 10:01:57, 'active', 1548.21);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (148, 'pfitzgerald', 'markriley@example.net', 'Susan Villanueva', '(300)278-0686x71773', 2025-01-21, 2025-05-12 23:35:22, 'active', 4495.63);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (149, 'idodson', 'kenneth10@example.com', 'Candice Stevens', '001-990-277-2625', 2025-05-31, 2025-04-02 09:45:12, 'active', 3413.51);
INSERT INTO users (instance_id, id, id, username, aud, email, role, full_name, email, phone, encrypted_password, birth_date, registration_date, email_confirmed_at, invited_at, status, total_spent, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, confirmed_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES (150, 'cruzhannah', 'phillipskaren@example.net', 'Kimberly Norton', '+1-719-750-8501x6579', 2023-12-16, 2025-04-10 12:15:14, 'suspended', 522.94);


-- Export completed successfully
