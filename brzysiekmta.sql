-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Czas generowania: 14 Mar 2018, 20:17
-- Wersja serwera: 10.1.26-MariaDB-0+deb9u1
-- Wersja PHP: 7.0.27-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `brzysiekmta`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_accounts`
--

CREATE TABLE `ms_accounts` (
  `id` int(11) NOT NULL,
  `login` text CHARACTER SET utf8 NOT NULL,
  `password` text CHARACTER SET utf8 NOT NULL,
  `email` text CHARACTER SET utf8 NOT NULL,
  `ip` text CHARACTER SET ascii NOT NULL,
  `serial` text CHARACTER SET ascii NOT NULL,
  `online` int(1) NOT NULL DEFAULT '0',
  `timestamp_registered` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `timestamp_last` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `sp` int(11) NOT NULL DEFAULT '0',
  `rank` int(1) NOT NULL DEFAULT '0',
  `warns` int(1) NOT NULL DEFAULT '0',
  `banned` int(1) NOT NULL DEFAULT '0',
  `premium` int(11) DEFAULT '0',
  `avatar` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `skin` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_achievements`
--

CREATE TABLE `ms_achievements` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `achievements` text COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_adminlogs`
--

CREATE TABLE `ms_adminlogs` (
  `id` int(11) NOT NULL,
  `admin_uid` int(11) NOT NULL,
  `player_uid` int(11) NOT NULL,
  `type` text NOT NULL,
  `reason` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_anim`
--

CREATE TABLE `ms_anim` (
  `anim_uid` smallint(5) UNSIGNED NOT NULL,
  `anim_command` varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'none',
  `anim_lib` varchar(16) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `anim_name` varchar(24) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'none',
  `anim_speed` float NOT NULL,
  `anim_opt1` tinyint(1) NOT NULL,
  `anim_opt2` tinyint(1) NOT NULL,
  `anim_opt3` tinyint(1) NOT NULL,
  `anim_opt4` tinyint(1) NOT NULL,
  `anim_opt5` tinyint(1) NOT NULL,
  `anim_action` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `ms_anim`
--

INSERT INTO `ms_anim` (`anim_uid`, `anim_command`, `anim_lib`, `anim_name`, `anim_speed`, `anim_opt1`, `anim_opt2`, `anim_opt3`, `anim_opt4`, `anim_opt5`, `anim_action`) VALUES
(169, 'idz1', 'PED', 'WALK_gang1', 4.1, 1, 1, 1, 1, 1, 0),
(170, 'idz2', 'PED', 'WALK_gang2', 4.1, 1, 1, 1, 1, 1, 0),
(171, 'idz3', 'PED', 'WOMAN_walksexy', 4, 1, 1, 1, 1, 1, 0),
(172, 'idz4', 'PED', 'WOMAN_walkfatold', 4, 1, 1, 1, 1, 1, 0),
(297, 'plac', 'DEALER', 'shop_pay', 4, 0, 0, 0, 0, 0, 0),
(175, 'idz6', 'PED', 'WALK_player', 6, 1, 1, 1, 1, 1, 0),
(174, 'idz5', 'PED', 'Walk_Wuzi', 4, 1, 1, 1, 1, 1, 0),
(176, 'pa', 'KISSING', 'gfwave2', 6, 0, 0, 0, 0, 0, 0),
(177, 'zmeczony', 'PED', 'IDLE_tired', 4, 1, 0, 0, 0, 0, 0),
(178, 'umyjrece', 'INT_HOUSE', 'wash_up', 4, 0, 0, 0, 0, 0, 0),
(179, 'medyk', 'MEDIC', 'CPR', 4, 0, 0, 0, 0, 0, 0),
(180, 'ranny', 'SWEET', 'Sweet_injuredloop', 4, 1, 0, 0, 1, 1, 0),
(181, 'salutuj', 'ON_LOOKERS', 'lkup_in', 4, 0, 1, 1, 1, 0, 0),
(182, 'wtf', 'RIOT', 'RIOT_ANGRY', 4, 0, 1, 1, 1, 1, 0),
(183, 'spoko', 'GANGS', 'prtial_gngtlkD', 4, 0, 0, 0, 0, 0, 0),
(184, 'napad', 'SHOP', 'ROB_Loop_Threat', 4, 1, 0, 0, 1, 1, 0),
(185, 'krzeslo', 'ped', 'SEAT_idle', 5, 1, 0, 0, 1, 1, 0),
(186, 'szukaj', 'COP_AMBIENT', 'Copbrowse_loop', 4, 1, 0, 0, 0, 0, 0),
(187, 'lornetka', 'ON_LOOKERS', 'shout_loop', 4, 1, 0, 0, 0, 0, 0),
(188, 'oh', 'MISC', 'plyr_shkhead', 4, 0, 0, 0, 0, 0, 0),
(189, 'oh2', 'OTB', 'wtchrace_lose', 4, 0, 1, 1, 0, 0, 0),
(190, 'wyciagnij', 'FOOD', 'SHP_Tray_Lift', 4, 0, 0, 0, 0, 0, 0),
(191, 'zdziwiony', 'PED', 'facsurp', 4, 0, 1, 1, 1, 1, 0),
(192, 'recemaska', 'POLICE', 'crm_drgbst_01', 6, 1, 0, 0, 1, 0, 0),
(193, 'krzeslojem', 'FOOD', 'FF_Sit_Eat1', 4, 1, 0, 0, 0, 0, 0),
(194, 'gogo', 'RIOT', 'RIOT_CHANT', 4, 1, 1, 1, 1, 0, 0),
(195, 'czekam', 'GRAVEYARD', 'prst_loopa', 4, 1, 0, 0, 1, 1, 0),
(196, 'garda', 'FIGHT_D', 'FightD_IDLE', 4, 1, 1, 1, 1, 0, 0),
(199, 'naprawia', 'CAR', 'Fixn_Car_Loop', 4, 1, 0, 0, 1, 1, 0),
(198, 'fotel', 'INT_HOUSE', 'LOU_Loop', 4, 1, 0, 0, 1, 1, 0),
(197, 'barman2', 'BAR', 'BARman_idle', 4, 0, 0, 0, 0, 0, 0),
(200, 'barman', 'BAR', 'Barserve_loop', 4, 1, 0, 0, 0, 0, 0),
(201, 'opieraj', 'GANGS', 'leanIDLE', 4, 1, 0, 0, 1, 1, 0),
(202, 'bar.nalej', 'BAR', 'Barserve_glass', 4, 0, 0, 0, 0, 0, 0),
(203, 'ramiona', 'COP_AMBIENT', 'Coplook_loop', 3, 1, 0, 0, 0, 0, 0),
(204, 'bar.wez', 'BAR', 'Barserve_bottle', 4, 0, 0, 0, 0, 0, 0),
(205, 'chowaj', 'ped', 'cower', 3, 1, 0, 0, 0, 0, 0),
(206, 'wez', 'BAR', 'Barserve_give', 4, 0, 0, 0, 0, 0, 0),
(207, 'fuck', 'ped', 'fucku', 4, 0, 0, 0, 0, 0, 0),
(208, 'klepnij', 'SWEET', 'sweet_ass_slap', 6, 0, 0, 0, 0, 0, 0),
(210, 'daj', 'DEALER', 'DEALER_DEAL', 8, 0, 0, 0, 0, 0, 0),
(211, 'pij', 'VENDING', 'VEND_Drink2_P', 4, 1, 1, 1, 1, 0, 0),
(212, 'start', 'CAR', 'flag_drop', 4, 0, 0, 0, 0, 0, 0),
(213, 'karta', 'HEIST9', 'Use_SwipeCard', 4, 0, 0, 0, 0, 0, 0),
(214, 'spray', 'GRAFFITI', 'spraycan_fire', 4, 1, 0, 0, 0, 1, 0),
(215, 'odejdz', 'POLICE', 'CopTraf_Left', 4, 0, 0, 0, 0, 0, 0),
(216, 'fotelk', 'JST_BUISNESS', 'girl_02', 4, 1, 0, 0, 1, 1, 0),
(217, 'chodz', 'POLICE', 'CopTraf_Come', 4, 0, 0, 0, 0, 0, 0),
(218, 'stoj', 'POLICE', 'CopTraf_Stop', 4, 0, 0, 0, 0, 0, 0),
(219, 'drapjaja', 'MISC', 'Scratchballs_01', 4, 1, 0, 0, 0, 0, 0),
(220, 'opieraj2', 'MISC', 'Plyrlean_loop', 4, 1, 0, 0, 0, 0, 0),
(221, 'walekonia', 'PAULNMAC', 'wank_loop', 4, 1, 0, 0, 0, 0, 0),
(222, 'popchnij', 'GANGS', 'shake_cara', 4, 0, 0, 0, 0, 0, 0),
(223, 'rzuc', 'GRENADE', 'WEAPON_throwu', 3, 0, 0, 0, 0, 0, 0),
(224, 'rap', 'RAPPING', 'RAP_A_Loop', 4, 1, 0, 0, 0, 0, 0),
(225, 'rap2', 'RAPPING', 'RAP_C_Loop', 4, 1, 0, 0, 0, 0, 0),
(226, 'rap3', 'RAPPING', 'RAP_B_Loop', 4, 1, 0, 0, 0, 0, 0),
(227, 'rap4', 'RAPPING', 'RAP_B_Loop', 4, 1, 0, 0, 0, 0, 0),
(228, 'glowka', 'WAYFARER', 'WF_Fwd', 4, 0, 0, 0, 0, 0, 0),
(229, 'skop', 'FIGHT_D', 'FightD_G', 4, 0, 0, 0, 0, 0, 0),
(230, 'siad', 'BEACH', 'ParkSit_M_loop', 4, 1, 0, 0, 0, 0, 0),
(231, 'krzeslo2', 'FOOD', 'FF_Sit_Loop', 4, 1, 0, 0, 0, 0, 0),
(232, 'krzeslo3', 'INT_OFFICE', 'OFF_Sit_Idle_Loop', 4, 1, 0, 0, 0, 0, 0),
(233, 'krzeslo4', 'INT_OFFICE', 'OFF_Sit_Bored_Loop', 4, 1, 0, 0, 0, 0, 0),
(234, 'krzeslo5', 'INT_OFFICE', 'OFF_Sit_Type_Loop', 4, 1, 0, 0, 0, 0, 0),
(235, 'padnij', 'PED', 'KO_shot_front', 4, 0, 1, 1, 1, 0, 0),
(236, 'padaczka', 'PED', 'FLOOR_hit_f', 4, 1, 0, 0, 0, 0, 0),
(238, 'crack', 'CRACK', 'crckdeth2', 4, 1, 0, 0, 0, 0, 0),
(252, 'lez3', 'BEACH', 'ParkSit_W_loop', 4, 1, 0, 0, 0, 0, 0),
(247, 'pijak', 'PED', 'WALK_DRUNK', 4, 1, 1, 1, 1, 1, 0),
(237, 'unik', 'PED', 'EV_dive', 4, 0, 1, 1, 1, 0, 0),
(239, 'bomb', 'BOMBER', 'BOM_Plant', 4, 0, 0, 0, 0, 0, 0),
(240, 'kominiarka', 'SHOP', 'ROB_Shifty', 4, 0, 0, 0, 0, 0, 0),
(241, 'rece', 'ROB_BANK', 'SHP_HandsUp_Scr', 4, 0, 1, 1, 1, 1, 0),
(242, 'tancz1', 'DANCING', 'bd_clap', 0, 1, 0, 0, 0, 0, 5),
(243, 'tancz2', 'DANCING', 'bd_clap1', 0, 1, 0, 0, 0, 0, 6),
(244, 'tancz3', 'DANCING', 'dance_loop', 0, 1, 0, 0, 0, 0, 7),
(245, 'tancz4', 'DANCING', 'DAN_Down_A', 0, 1, 0, 0, 0, 0, 8),
(246, 'tancz5', 'DANCING', 'DAN_Left_A', 2, 1, 0, 0, 0, 0, 0),
(248, 'nie', 'GANGS', 'Invite_No', 4, 0, 0, 0, 0, 0, 0),
(249, 'lokiec', 'CAR', 'Sit_relaxed', 4, 1, 1, 1, 1, 0, 0),
(250, 'go', 'RIOT', 'RIOT_PUNCHES', 4, 0, 0, 0, 0, 0, 0),
(251, 'stack1', 'GHANDS', 'gsign2LH', 4, 0, 0, 0, 0, 0, 0),
(253, 'lez1', 'BEACH', 'bather', 4, 1, 0, 0, 0, 0, 0),
(254, 'lez2', 'BEACH', 'Lay_Bac_Loop', 4, 1, 0, 0, 0, 0, 0),
(255, 'padnij2', 'PED', 'KO_skid_front', 4, 0, 1, 1, 1, 0, 0),
(256, 'bat', 'CRACK', 'Bbalbat_Idle_01', 4, 1, 1, 1, 1, 1, 0),
(257, 'bat2', 'CRACK', 'Bbalbat_Idle_02', 4, 0, 1, 1, 1, 1, 0),
(258, 'stack2', 'GHANDS', 'gsign2', 4, 0, 1, 1, 1, 1, 0),
(259, 'stack3', 'GHANDS', 'gsign4', 4, 0, 1, 1, 1, 1, 0),
(260, 'taichi', 'PARK', 'Tai_Chi_Loop', 4, 1, 0, 0, 0, 0, 0),
(266, 'papieros', 'SMOKING', 'M_smklean_loop', 4, 1, 0, 0, 0, 0, 0),
(267, 'wymiotuj', 'FOOD', 'EAT_Vomit_P', 3, 0, 0, 0, 0, 0, 0),
(268, 'fuck2', 'RIOT', 'RIOT_FUKU', 4, 0, 0, 0, 0, 0, 0),
(209, 'cmon', 'RYDER', 'RYD_Beckon_01', 4, 0, 1, 1, 0, 0, 0),
(269, 'koks', 'PED', 'IDLE_HBHB', 4, 1, 0, 0, 1, 0, 0),
(270, 'idz7', 'PED', 'WOMAN_walkshop', 4, 1, 1, 1, 1, 1, 0),
(271, 'cry', 'GRAVEYARD', 'mrnF_loop', 4, 1, 0, 0, 1, 0, 0),
(272, 'rozciagaj', 'PLAYIDLES', 'stretch', 4, 0, 0, 0, 0, 0, 0),
(275, 'bagaznik', 'POOL', 'POOL_Place_White', 4, 0, 0, 0, 1, 0, 0),
(276, 'wywaz', 'GANGS', 'shake_carK', 4, 0, 0, 0, 0, 0, 0),
(277, 'skradajsie', 'PED', 'Player_Sneak', 6, 1, 1, 1, 1, 1, 0),
(278, 'przycisk', 'CRIB', 'CRIB_use_switch', 4, 0, 0, 0, 0, 0, 0),
(279, 'tancz6', 'DANCING', 'DAN_Loop_A', 4, 1, 0, 0, 0, 0, 0),
(280, 'tancz7', 'DANCING', 'DAN_Right_A', 4, 1, 0, 0, 0, 0, 0),
(281, 'idz8', 'PED', 'walk_shuffle', 4, 1, 1, 1, 1, 1, 0),
(282, 'stack4', 'LOWRIDER', 'prtial_gngtlkB', 4, 0, 0, 0, 0, 0, 0),
(283, 'stack5', 'LOWRIDER', 'prtial_gngtlkC', 4, 0, 1, 1, 1, 1, 0),
(284, 'stack6', 'lowrider', 'prtial_gngtlkD', 4, 0, 0, 0, 0, 0, 0),
(285, 'stack7', 'lowrider', 'prtial_gngtlkE', 4, 0, 0, 0, 0, 0, 0),
(286, 'stack8', 'lowrider', 'prtial_gngtlkF', 4, 0, 0, 0, 0, 0, 0),
(287, 'stack9', 'lowrider', 'prtial_gngtlkG', 4, 0, 0, 0, 0, 0, 0),
(288, 'stack10', 'lowrider', 'prtial_gngtlkH', 4, 0, 1, 1, 1, 1, 0),
(289, 'tancz8', 'DANCING', 'DAN_Up_A', 4, 1, 0, 0, 0, 0, 0),
(290, 'kasjer', 'INT_SHOP', 'shop_cashier', 4, 0, 0, 0, 0, 0, 0),
(291, 'idz9', 'wuzi', 'wuzi_walk', 4, 1, 1, 1, 1, 1, 0),
(292, 'taxi', 'misc', 'hiker_pose', 4, 0, 0, 0, 1, 0, 0),
(293, 'wskaz', 'on_lookers', 'pointup_loop', 4, 0, 0, 0, 1, 0, 0),
(294, 'wskaz2', 'on_lookers', 'point_loop', 4, 0, 0, 0, 1, 0, 0),
(295, 'podpisz', 'otb', 'betslp_loop', 4, 0, 0, 0, 0, 0, 0),
(380, 'celuj', 'SWORD', 'sword_block', 4, 0, 1, 1, 1, 1, 0),
(298, 'deal', 'DEALER', 'DEALER_DEAL', 4, 0, 1, 1, 1, 1, 0),
(299, 'pal5', 'SMOKING', 'M_smk_in', 4, 0, 0, 0, 0, 0, 0),
(300, 'pal2', 'SMOKING', 'M_smklean_loop', 4, 1, 0, 0, 0, 0, 0),
(301, 'pal3', 'SMOKING', 'M_smkstnd_loop', 4, 1, 0, 0, 0, 0, 0),
(302, 'pal4', 'SMOKING', 'M_smk_drag', 4, 0, 1, 1, 1, 1, 0),
(303, 'fotel2', 'INT_HOUSE', 'LOU_Out', 3, 0, 0, 0, 0, 0, 0),
(304, 'ranny2', 'CRACK', 'crckidle1', 4, 0, 1, 1, 1, 1, 0),
(305, 'ranny3', 'KNIFE', 'KILL_Knife_Ped_Die', 3, 0, 1, 1, 1, 1, 0),
(306, 'ranny4', 'WUZI', 'CS_Dead_Guy', 4, 0, 1, 1, 1, 1, 0),
(307, 'cartel', 'CAR_CHAT', 'carfone_in', 3, 0, 1, 1, 1, 1, 0),
(308, 'cartel2', 'CAR_CHAT', 'carfone_out', 3, 0, 0, 0, 0, 0, 0),
(309, 'przeladujd', 'COLT45', 'colt45_reload', 4, 0, 1, 1, 1, 1, 0),
(310, 'przeladujm', 'BUDDY', 'buddy_crouchreload', 4, 0, 1, 1, 1, 1, 0),
(311, 'bron', 'PED', 'IDLE_armed', 4, 0, 1, 1, 1, 1, 0),
(312, 'spray', 'SPRAYCAN', 'spraycan_full', 4, 1, 1, 1, 1, 1, 0),
(313, 'gtalk', 'GANGS', 'prtial_gngtlkB', 4, 1, 1, 1, 1, 1, 0),
(314, 'gtalk2', 'GANGS', 'prtial_gngtlkD', 4, 1, 1, 1, 1, 1, 0),
(315, 'gtalk3', 'GANGS', 'prtial_gngtlkH', 4, 1, 1, 1, 1, 1, 0),
(316, 'kibel', 'MISC', 'SEAT_LR', 4, 0, 1, 1, 1, 1, 0),
(317, 'bronidz', 'PED', 'WALK_armed', 4, 1, 1, 1, 1, 1, 0),
(323, 'zebraj', 'POOR', 'WINWASH_Start', 4, 0, 1, 1, 1, 1, 0),
(324, 'mysl', 'COP_AMBIENT', 'Coplook_think', 4, 0, 1, 1, 1, 1, 0),
(325, 'dajprezent', 'KISSING', 'gift_give', 4, 0, 0, 0, 0, 0, 0),
(326, 'machaj', 'ON_LOOKERS', 'wave_loop', 4, 1, 1, 1, 1, 1, 0),
(327, 'wezprezent', 'KISSING', 'gift_get', 3, 0, 0, 0, 0, 0, 0),
(328, 'skuj', 'BOMBER', 'BOM_Plant', 4, 0, 0, 0, 0, 0, 0),
(329, 'podnies', 'CARRY', 'liftup', 4, 0, 0, 0, 0, 0, 0),
(330, 'poloz', 'CARRY', 'putdwn', 4, 0, 0, 0, 0, 0, 0),
(331, 'neo', 'MISC', 'KAT_Throw_K', 4, 0, 1, 1, 1, 1, 0),
(332, 'aparat', 'CAMERA', 'camcrch_cmon', 4, 0, 1, 1, 1, 1, 0),
(333, 'aparat2', 'CAMERA', 'camcrch_idleloop', 4, 0, 1, 1, 1, 1, 0),
(334, 'aparat3', 'CAMERA', 'piccrch_in', 4, 0, 1, 1, 1, 1, 0),
(335, 'aparat4', 'CAMERA', 'piccrch_take', 4, 0, 1, 1, 1, 1, 0),
(336, 'cellin', '0', '0', 4, 0, 1, 1, 1, 1, 1),
(364, 'rece2', 'SHOP', 'SHP_Rob_React', 4.1, 0, 1, 1, 1, 1, 0),
(370, 'cartalk', 'car_chat', 'car_talkm_loop', 2, 0, 1, 1, 1, 1, 0),
(339, 'pal', 'GANGS', 'smkcig_prtl', 4, 1, 0, 0, 0, 0, 0),
(340, 'ruszaj', 'POLICE', 'CopTraf_Left', 4, 1, 1, 1, 1, 1, 0),
(341, 'idz', 'PED', 'WALK_civi', 4, 1, 1, 1, 1, 1, 0),
(352, 'car', 'GHETTO_DB', 'GDB_Car2_SMO', 3, 0, 0, 0, 0, 0, 0),
(367, 'telefon', 'PED', 'phone_in', 4, 0, 1, 1, 1, 1, 0),
(366, 'lez4', 'BEACH', 'SitnWait_loop_W', 4, 1, 0, 0, 0, 0, 0),
(357, 'bitchslap2', 'SNM', 'SPANKINGP', 4.1, 0, 1, 1, 1, 1, 0),
(359, 'zmeczony2', 'SNM', 'SPANKEDP', 4.1, 0, 1, 1, 1, 1, 0),
(360, 'padnij3', 'SNM', 'SPANKING_ENDW', 4.1, 0, 1, 1, 1, 1, 0),
(361, 'bitchslap3', 'SNM', 'SPANKING_ENDP', 4.1, 0, 1, 1, 1, 1, 0),
(363, 'jack', 'CRIB', 'CRIB_Use_Switch', 4.1, 0, 1, 1, 1, 1, 0),
(368, 'tak', 'GANGS', 'Invite_Yes', 4, 0, 0, 0, 0, 0, 0),
(371, 'krzeslo6', 'misc', 'Seat_talk_02', 2, 1, 0, 0, 0, 0, 0),
(372, 'nozwbij', 'knife', 'Knife_4', 6, 1, 0, 0, 0, 0, 0),
(373, 'ramiona2', 'cop_ambient', 'Coplook_shake', 3, 0, 1, 1, 1, 1, 0),
(374, 'plac2', 'casino', 'Slot_in', 4, 0, 0, 0, 0, 0, 0),
(375, 'zlap', 'casino', 'dealone', 2, 0, 1, 1, 1, 1, 0),
(376, 'czekam2', 'casino', 'cards_loop', 4, 0, 1, 1, 1, 1, 0),
(377, 'skrzynia', 'box', 'catch_box', 1, 0, 0, 0, 0, 0, 0),
(378, 'szok', 'on_lookers', 'panic_loop', 4, 0, 1, 1, 1, 1, 0),
(379, 'sikaj', 'paulnmac', 'Piss_loop', 3, 0, 1, 1, 1, 1, 0),
(381, 'tancz9', 'DANCING', 'dnce_M_a', 4, 1, 0, 0, 0, 0, 0),
(382, 'tancz10', 'DANCING', 'dnce_M_b', 0, 1, 0, 0, 0, 0, 5),
(383, 'tancz11', 'DANCING', 'dnce_M_c', 0, 1, 0, 0, 0, 0, 5),
(384, 'tancz12', 'DANCING', 'dnce_M_d', 0, 1, 0, 0, 0, 0, 5),
(385, 'tancz13', 'DANCING', 'dnce_M_e', 0, 1, 0, 0, 0, 0, 5),
(386, 'strip1', 'STRIP', 'STR_Loop_A', 0, 1, 0, 0, 0, 0, 5),
(387, 'strip2', 'STRIP', 'STR_Loop_B', 0, 1, 0, 0, 0, 0, 5),
(388, 'strip3', 'STRIP', 'STR_Loop_C', 0, 1, 0, 0, 0, 0, 5);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_bans`
--

CREATE TABLE `ms_bans` (
  `id` int(11) NOT NULL,
  `accountid` int(11) DEFAULT NULL,
  `bannedby` int(11) NOT NULL,
  `serial` varchar(32) CHARACTER SET ascii DEFAULT NULL COMMENT 'serial',
  `ip` varchar(100) NOT NULL,
  `date_from` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ban od',
  `date_to` int(11) NOT NULL COMMENT 'ban do',
  `reason` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_casino-stats`
--

CREATE TABLE `ms_casino-stats` (
  `sm_give` int(11) NOT NULL DEFAULT '0',
  `sm_take` int(11) NOT NULL DEFAULT '0',
  `card_give` int(11) NOT NULL DEFAULT '0',
  `card_take` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_challenges`
--

CREATE TABLE `ms_challenges` (
  `id` int(11) NOT NULL,
  `playerName` varchar(30) NOT NULL,
  `uid` int(11) NOT NULL,
  `track` varchar(50) CHARACTER SET utf8 NOT NULL,
  `vehicle` int(3) NOT NULL,
  `time` int(8) NOT NULL COMMENT 'w milisekundach'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_custominteriors`
--

CREATE TABLE `ms_custominteriors` (
  `id` int(11) NOT NULL,
  `enterPos` text NOT NULL,
  `objects` text NOT NULL,
  `disableFurniture` int(1) NOT NULL DEFAULT '1' COMMENT 'jeśli disableFurniture == 0 to objects służy jako id interioru GTA'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_custominteriors`
--

INSERT INTO `ms_custominteriors` (`id`, `enterPos`, `objects`, `disableFurniture`) VALUES
(1, '[ [ 382.20,-152.34,1034 ] ]', '[[ [14594,407.4003900,-145.7002000,1032.7000000,0.0000000,0.0000000,0.0000000,250],\r\n[9339,385.2998000,-167.5000000,1033.4000000,90.0000000,0.0000000,270.0000000,250],\r\n[9339,383.9003900,-167.5000000,1033.4000000,90.0000000,0.0000000,270.0000000,250],\r\n[9339,381.0996100,-167.5000000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,379.8999900,-167.8400000,1033.4000000,90.0000000,0.0000000,120.7500000,250],\r\n[9339,378.7000100,-168.5549900,1033.4000000,90.0000000,0.0000000,120.7450000,250],\r\n[9339,382.5000000,-167.5000000,1048.2000000,90.0000000,0.0000000,270.0000000,250],\r\n[9339,379.8999900,-151.8999900,1033.4000200,90.0000000,0.0000000,0.0000000,250],\r\n[9339,379.8999900,-153.1000100,1033.4000000,90.0000000,0.0000000,0.0000000,250],\r\n[9339,379.8999900,-154.5000000,1033.4000000,90.0000000,0.0000000,0.0000000,250],\r\n[9339,379.9003900,-157.4003900,1033.4000000,90.0000000,0.0000000,179.9950000,250],\r\n[9339,379.8999900,-158.7000000,1033.4000000,90.0000000,0.0000000,0.0000000,250],\r\n[9339,379.3999900,-159.3000000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,378.0000000,-159.3000000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,376.6000100,-159.3000000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,375.3999900,-159.6479900,1033.4000000,90.0000000,0.0000000,121.2500000,250],\r\n[9339,374.2000100,-160.3810000,1033.4000000,90.0000000,0.0000000,121.2450000,250],\r\n[9339,373.0000000,-161.1200000,1033.4000000,90.0000000,0.0000000,121.2450000,250],\r\n[1491,381.7998000,-167.4003900,1032.7000000,0.0000000,0.0000000,0.0000000,250],\r\n[1491,380.0000000,-156.7000000,1032.7000000,0.0000000,0.0000000,90.7500000,250],\r\n[9339,379.8999900,-155.8999900,1048.2000000,90.0000000,0.0000000,180.0000000,250],\r\n[9339,379.8999900,-157.0000000,1048.2000000,90.0000000,0.0000000,179.9950000,250],\r\n[9339,378.8999900,-167.5000000,1033.4000000,90.0000000,0.0000000,179.9950000,250],\r\n[9339,378.8999900,-166.1000100,1033.4000000,90.0000000,0.0000000,179.9950000,250],\r\n[9339,378.9003900,-164.7002000,1033.4000000,90.0000000,0.0000000,179.9950000,250],\r\n[9339,373.2999900,-163.0000000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,374.5000000,-163.3600000,1033.4000000,90.0000000,0.0000000,56.0000000,250],\r\n[1491,375.1000100,-163.7000000,1032.7000000,0.0000000,0.0000000,325.2500000,250],\r\n[9339,378.0920100,-165.3400000,1033.4000000,90.0000000,0.0000000,90.0000000,250],\r\n[9339,376.1000100,-167.5000000,1032.5601000,0.0000000,90.0000000,90.0000000,250],\r\n[9339,376.8999900,-164.9800000,1033.4000000,90.0000000,0.0000000,236.0000000,250],\r\n[9339,375.6000100,-164.1000100,1048.2222000,90.0000000,0.0000000,55.9970000,250],\r\n[9339,375.8999900,-164.3000000,1048.2000000,90.0000000,0.0000000,55.9970000,250],\r\n[1505,381.4400000,-151.1000100,1032.7000000,0.0000000,0.0000000,0.0000000,250] ]]\r\n', 1),
(2, '[[74.47,3024.93,63.30]]', '[[\r\n[15054,70.5000000,3022.6001000,64.3000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,70.6000000,3027.2000000,62.3000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,74.1500000,3023.0000000,62.3000000,0.0000000,0.0000000,180.0000000,250],\r\n[1502,69.3000000,3024.3000000,62.3000000,0.0000000,0.0000000,90.0000000,250],\r\n[1506,75.5000000,3024.3000000,62.3000000,0.0000000,0.0000000,90.0000000,250],\r\n[1506,83.0000000,3030.6001000,60.8000000,0.0000000,0.0000000,90.0000000,250],\r\n]],', 1),
(3, '[[ -171.63,2982.45,48.41 ]]', '[[\r\n[14718,-174.5000000,2986.3999000,47.4000000,0.0000000,0.0000000,0.0000000,250],\r\n[1506,-172.3000000,2981.5000000,47.4000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,-166.8999900,2985.5000000,47.4000000,0.0000000,0.0000000,270.0000000,250],\r\n[1502,-175.6000100,2981.8000000,47.4000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-173.6000100,2987.3000000,47.4000000,0.0000000,0.0000000,90.0000000,250]\r\n]]', 1),
(4, '[[-335.16,3030.88,65.10]]', '[[\r\n[14713,-340.2000100,3034.7000000,65.9000000,0.0000000,0.0000000,0.0000000,250],\r\n[1506,-335.7999900,3029.7000000,64.1000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,-342.7999900,3037.4500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-336.2999900,3032.4500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-333.8999900,3032.7500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-333.8999900,3037.0901000,64.1000000,0.0000000,0.0000000,90.0000000,250]\r\n]]', 1),
(5, '[[ -335.04,3030.94,65.10 ]]', '[[\r\n[14713,-340.2000100,3034.7000000,65.9000000,0.0000000,0.0000000,0.0000000,250],\r\n[1506,-335.7999900,3029.7000000,64.1000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,-342.7999900,3037.4500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-336.2999900,3032.4500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-333.8999900,3032.7500000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-333.8999900,3037.0901000,64.1000000,0.0000000,0.0000000,90.0000000,250],\r\n[14754,-1359.2000000,3049.7000000,99.2000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,-1357.8000000,3043.8999000,95.3000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-1357.8000000,3053.8999000,95.3000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-1361.8000000,3053.8999000,95.3000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-1364.0000000,3056.3000000,99.8000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-1357.8000000,3054.3000000,99.8000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,-1362.6700000,3061.1001000,99.8000000,0.0000000,0.0000000,0.0000000,250],\r\n[1506,-1362.6500000,3040.6001000,95.3000000,0.0000000,0.0000000,0.0000000,250],\r\n]]', 1),
(6, '[[1598.3,-2133.3,1944.4]]', '[[\r\n[14702,1595.5000000,-2121.7000000,1948.3000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,1593.5000000,-2127.8000000,1948.2000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,1598.4670000,-2116.8000000,1948.1350000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,1596.0000000,-2116.8999000,1944.0000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,1593.4000000,-2122.8000000,1944.0300000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,1593.4000000,-2129.4700000,1944.0300000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,1600.7000000,-2133.0000000,1944.0300000,0.0000000,0.0000000,90.0000000,250],\r\n[1504,1597.4301000,-2135.0300000,1944.0100000,0.0000000,0.0000000,0.0000000,250],\r\n[1419,1600.4000000,-2128.2000000,1948.7000000,0.0000000,0.0000000,0.0000000,250],\r\n[1419,1598.4000000,-2126.2000000,1948.7000000,0.0000000,0.0000000,90.0000000,250]\r\n]]', 1),
(7, '[[ 1141.5, -2873.7, 1383.1 ]]', '[[\r\n[15054,1130.1000000,-2882.5000000,1386.0000000,0.0000000,0.0000000,0.0000000,250],\r\n[1506,1142.7000000,-2872.9500000,1382.5000000,0.0000000,0.0000000,270.0000000,250],\r\n[1502,1130.2000000,-2877.8000000,1384.0000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,1132.2000000,-2882.2000000,1384.0000000,0.0000000,0.0000000,0.0000000,250],\r\n[1502,1128.9000000,-2880.8000000,1384.0000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,1135.1000000,-2880.8000000,1384.0000000,0.0000000,0.0000000,90.0000000,250]\r\n]]', 1),
(8, '[[ 1132.1, -2874.3, 1404.4 ]]', '[[\r\n[15031,1129.1000000,-2870.6001000,1403.6000000,0.0000000,0.0000000,0.0000000,250],\r\n[1504,1131.3350000,-2875.5000000,1403.6000000,0.0000000,0.0000000,0.0000000,250],\r\n[1567,1135.9000000,-2873.2000000,1403.6000000,0.0000000,0.0000000,90.0000000,250],\r\n[1502,1128.1000000,-2875.2000000,1403.6000000,0.0000000,0.0000000,90.0000000,250]\r\n]]', 1),
(9, '[[ 2233.68,-1114.02,1050.88 ]]', '5', 0),
(10, '[[ 2365.25,-1134.23,1050.88 ]]', '8', 0),
(11, '[[  2282.95,-1139.40,1050.90 ]]', '11', 0),
(12, '[[ 1298.96,-795.33,1084.01 ]]', '5', 0),
(13, '[[ 82.68,1323.35,1083.87 ]]', '9', 0),
(14, '[[140.34,1367.15,1083.86]]', '5', 0),
(15, '[[ 261.19,1285.05,1080.26 ]]', '4', 0),
(16, '[[ 2317.82,-1026.39,1050.22 ]]', '9', 0),
(17, '[[ 2237.59,-1080.87,1049.02 ]]', '2', 0),
(18, '[[ 2217.02,-1076.31,1050.48 ]]', '1', 0),
(19, '[[ 2269.25,-1210.67,1047.56 ]]', '10', 0),
(20, '[[ 2324.56, -1148.6, 1050.71 ]]', '12', 0),
(21, '[[ 2523.43, -1285.75, 1054.64 ]]', '2', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_entrances`
--

CREATE TABLE `ms_entrances` (
  `id` int(11) NOT NULL,
  `name` text,
  `opis` text CHARACTER SET utf8 COLLATE utf8_polish_ci COMMENT 'opis wyswietlany na ekranie',
  `pickupid` int(11) NOT NULL DEFAULT '1239',
  `pk_pos` varchar(64) CHARACTER SET latin1 DEFAULT '[[ 0.0, 0.0, 0.0, 0.0 ]]',
  `pki` int(11) NOT NULL DEFAULT '0',
  `pkv` int(11) NOT NULL DEFAULT '0',
  `pk_tel` varchar(64) CHARACTER SET latin1 DEFAULT '[[ 0.0, 0.0, 0.0, 0.0 ]]',
  `teli` int(11) NOT NULL DEFAULT '0',
  `telv` int(11) NOT NULL DEFAULT '0',
  `music` text CHARACTER SET ascii NOT NULL,
  `music_volume` float NOT NULL DEFAULT '0.6',
  `blip` int(3) NOT NULL DEFAULT '36',
  `icon` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `ms_entrances`
--

INSERT INTO `ms_entrances` (`id`, `name`, `opis`, `pickupid`, `pk_pos`, `pki`, `pkv`, `pk_tel`, `teli`, `telv`, `music`, `music_volume`, `blip`, `icon`) VALUES
(28, 'Przejście', '---', 1239, '[[ 559.5461,-2033.9458,16.1743, 0.0 ]]', 0, 10, '[[ 559.4380,-2092.8203,2.67120, 0.0 ]]', 0, 10, '', 0.6, -1, ''),
(29, 'Skocznia', 'Ostrożnie!', 1239, '[[ 578.6855,-2195.5337,1.6288, 0.0 ]]', 0, 10, '[[ 578.5896,-2194.7065,7.1380, 0.0 ]]', 0, 10, '', 0.6, -1, ''),
(14, 'Kopalnia', 'Miejsce wydobycia wapieni\n', 1239, '[ [ 2062.29345703125, -491.1194763183594, 72.28235626220703 ] ]', 0, 0, '[ [ -3503.0458984375, 755.9766235351563, 36.86875152587891 ] ]', 0, 0, '', 0.6, 41, 'job'),
(26, 'Domek na drzewie', 'Autor: L4nCeR', 1239, '[[ 1870.25, 201.22, 31.9, 0.0 ]]', 0, 0, '[[ 1870.25, 203.22, 42.6, 0.0 ]]', 0, 0, '', 0.6, -1, ''),
(18, 'ALHAMBRA Club', 'Najlepsze imprezy w całym San Andreas!\r\nZapraszamy!', 1239, '[ [ 1836.333129882813, -1682.5869140625, 13.35233497619629 ] ]', 0, 0, '[ [ 493.390991,-22.722799,1000.679687 ] ]', 17, 0, 'http://gr-relay-4.gaduradio.pl/2', 1, 48, 'music'),
(23, 'Kasyno', 'Kasyno w Las Venturas', 1239, '[[ 2019.9689941406, 1007.7012939453, 10.8203125, 0.0 ]]', 0, 0, '[[ 2013.3005371094, 1670.5057373047, 998.55310058594, 293.0 ]]', 1, 0, 'http://gr-relay-4.gaduradio.pl/64', 0.4, -1, 'casino'),
(25, 'Przejście', '---', 1239, '[[ 1893.42,-4461.27,13.99, 220 ]]', 0, 0, '[[ 1921.42,-4489.46,13.39, 220 ]]', 0, 0, '', 0.6, -1, ''),
(24, 'Basen w SF', 'Chcesz (się) zamoczyć? Zapraszamy do nas!', 1239, '[[ -1989, 1040.5, 55.7, 0.0 ]]', 0, 0, '[[ 575.7503,-2046.9207,16.1670, 0.0 ]]', 0, 10, 'http://gr-relay-4.gaduradio.pl/2', 0.6, -1, '');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_furniture`
--

CREATE TABLE `ms_furniture` (
  `id` int(11) NOT NULL,
  `objectid` int(11) NOT NULL,
  `type` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `houseid` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `pos` varchar(200) NOT NULL,
  `rot` varchar(200) NOT NULL,
  `interior` int(3) NOT NULL DEFAULT '-1',
  `dimension` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_furnitureshop`
--

CREATE TABLE `ms_furnitureshop` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `type` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_furnitureshop`
--

INSERT INTO `ms_furnitureshop` (`id`, `model`, `price`, `type`) VALUES
(1, 19172, 150, 'picture'),
(2, 19173, 150, 'picture'),
(3, 19174, 150, 'picture'),
(4, 19175, 150, 'picture'),
(5, 19175, 150, 'picture'),
(6, 3964, 30, 'picture'),
(7, 3963, 30, 'picture'),
(8, 3962, 30, 'picture'),
(9, 2289, 40, 'picture'),
(10, 2288, 40, 'picture'),
(11, 2287, 40, 'picture'),
(12, 2286, 40, 'picture'),
(13, 2285, 40, 'picture'),
(14, 2284, 40, 'picture'),
(15, 2283, 40, 'picture'),
(16, 2282, 40, 'picture'),
(17, 2281, 40, 'picture'),
(18, 2279, 40, 'picture'),
(19, 2278, 40, 'picture'),
(20, 2277, 40, 'picture'),
(21, 2276, 40, 'picture'),
(22, 2275, 40, 'picture'),
(23, 2274, 40, 'picture'),
(24, 2273, 40, 'picture'),
(25, 2272, 40, 'picture'),
(26, 2271, 40, 'picture'),
(27, 2270, 40, 'picture'),
(28, 2269, 40, 'picture'),
(29, 2268, 40, 'picture'),
(30, 2267, 40, 'picture'),
(31, 2266, 40, 'picture'),
(32, 2264, 40, 'picture'),
(33, 2261, 40, 'picture'),
(34, 2257, 50, 'picture'),
(35, 2256, 50, 'picture'),
(36, 2255, 50, 'picture'),
(37, 2254, 50, 'picture'),
(38, 1755, 150, 'armchair'),
(39, 1758, 150, 'armchair'),
(40, 1759, 150, 'armchair'),
(41, 1762, 150, 'armchair'),
(42, 1765, 150, 'armchair'),
(43, 1767, 150, 'armchair'),
(44, 1769, 150, 'armchair'),
(45, 1746, 200, 'armchair'),
(46, 2291, 200, 'armchair'),
(47, 2292, 200, 'armchair'),
(48, 2295, 200, 'armchair'),
(49, 1705, 200, 'armchair'),
(50, 1704, 200, 'armchair'),
(51, 1724, 200, 'armchair'),
(52, 1708, 200, 'armchair'),
(53, 1711, 150, 'armchair'),
(54, 1729, 150, 'armchair'),
(55, 1727, 150, 'armchair'),
(56, 1735, 150, 'armchair'),
(57, 1768, 300, 'sofa'),
(58, 1766, 300, 'sofa'),
(59, 1764, 300, 'sofa'),
(60, 1763, 300, 'sofa'),
(61, 1760, 300, 'sofa'),
(62, 1757, 300, 'sofa'),
(63, 1756, 300, 'sofa'),
(64, 1753, 400, 'sofa'),
(65, 1713, 400, 'sofa'),
(66, 1728, 300, 'sofa'),
(67, 1712, 300, 'sofa'),
(68, 1710, 300, 'sofa'),
(69, 1709, 350, 'sofa'),
(70, 1707, 400, 'sofa'),
(71, 1706, 400, 'sofa'),
(72, 1702, 400, 'sofa'),
(73, 1723, 400, 'sofa'),
(74, 1703, 400, 'sofa'),
(75, 1726, 400, 'sofa'),
(76, 1714, 100, 'chair'),
(77, 1720, 100, 'chair'),
(78, 1739, 150, 'chair'),
(79, 2079, 150, 'chair'),
(80, 2120, 150, 'chair'),
(83, 2636, 200, 'chair'),
(84, 2788, 100, 'chair'),
(85, 1822, 350, 'bench'),
(86, 1815, 300, 'bench'),
(87, 1827, 300, 'bench'),
(88, 2081, 250, 'bench'),
(89, 2082, 250, 'bench'),
(90, 2370, 200, 'bench'),
(91, 1823, 250, 'bench'),
(92, 1818, 200, 'bench'),
(94, 1814, 200, 'bench'),
(95, 1817, 300, 'bench'),
(96, 2024, 250, 'bench'),
(97, 2357, 300, 'bench'),
(98, 2126, 300, 'bench'),
(99, 2234, 250, 'bench'),
(100, 2236, 300, 'bench'),
(101, 1826, 300, 'desk'),
(102, 1826, 300, 'desk'),
(104, 2173, 250, 'desk'),
(105, 2180, 200, 'desk'),
(106, 2205, 200, 'desk'),
(107, 2209, 250, 'desk'),
(109, 1700, 600, 'bed'),
(110, 1701, 600, 'bed'),
(111, 1745, 500, 'bed'),
(112, 1794, 500, 'bed'),
(113, 1795, 400, 'bed'),
(114, 1796, 300, 'bed'),
(115, 1798, 350, 'bed'),
(116, 1799, 350, 'bed'),
(117, 1801, 250, 'bed'),
(118, 1802, 300, 'bed'),
(119, 2090, 350, 'bed'),
(120, 2298, 400, 'bed'),
(121, 2299, 400, 'bed'),
(122, 2301, 350, 'bed'),
(123, 2302, 250, 'bed'),
(125, 2575, 400, 'bed'),
(128, 1730, 400, 'wardrobe'),
(129, 1416, 400, 'wardrobe'),
(130, 1417, 400, 'wardrobe'),
(131, 14556, 400, 'wardrobe'),
(132, 1740, 300, 'wardrobe'),
(133, 1741, 300, 'wardrobe'),
(134, 1743, 300, 'wardrobe'),
(135, 2306, 300, 'wardrobe'),
(136, 2307, 300, 'wardrobe'),
(137, 2323, 300, 'wardrobe'),
(138, 2328, 250, 'wardrobe'),
(139, 2329, 250, 'wardrobe'),
(140, 2330, 250, 'wardrobe'),
(141, 2087, 300, 'wardrobe'),
(142, 2088, 300, 'wardrobe'),
(143, 2094, 300, 'wardrobe'),
(144, 2095, 300, 'wardrobe'),
(145, 1742, 400, 'wardrobe'),
(146, 2025, 400, 'wardrobe'),
(147, 2065, 150, 'wardrobe'),
(148, 2066, 200, 'wardrobe'),
(149, 2067, 200, 'wardrobe'),
(150, 2197, 200, 'wardrobe'),
(151, 2609, 200, 'wardrobe'),
(152, 2610, 200, 'wardrobe'),
(153, 2021, 300, 'wardrobe'),
(154, 2020, 300, 'wardrobe'),
(155, 2046, 300, 'wardrobe'),
(156, 2078, 300, 'wardrobe'),
(157, 2161, 400, 'wardrobe'),
(158, 2162, 400, 'wardrobe'),
(159, 2608, 350, 'wardrobe'),
(160, 2164, 400, 'wardrobe'),
(161, 2163, 400, 'wardrobe'),
(162, 2167, 400, 'wardrobe'),
(163, 2200, 400, 'wardrobe'),
(164, 2191, 300, 'wardrobe'),
(165, 2199, 250, 'wardrobe'),
(166, 2204, 450, 'wardrobe'),
(172, 2708, 300, 'wardrobe'),
(173, 2576, 300, 'wardrobe'),
(176, 2001, 100, 'plant'),
(178, 948, 100, 'plant'),
(179, 2194, 75, 'plant'),
(180, 2195, 75, 'plant'),
(181, 15038, 75, 'plant'),
(182, 2241, 75, 'plant'),
(183, 2253, 75, 'plant'),
(184, 2245, 75, 'plant'),
(185, 2247, 50, 'plant'),
(186, 2249, 50, 'plant'),
(187, 2251, 50, 'plant'),
(188, 2811, 75, 'plant'),
(189, 2515, 150, 'toilet'),
(190, 2518, 150, 'toilet'),
(191, 2523, 150, 'toilet'),
(192, 2524, 150, 'toilet'),
(193, 2514, 200, 'toilet'),
(194, 2521, 150, 'toilet'),
(195, 2525, 150, 'toilet'),
(196, 2528, 200, 'toilet'),
(197, 2738, 150, 'toilet'),
(198, 2018, 250, 'toilet'),
(199, 1208, 250, 'toilet'),
(200, 2750, 100, 'toilet'),
(201, 2751, 30, 'toilet'),
(202, 2749, 30, 'toilet'),
(203, 2752, 30, 'toilet'),
(204, 2517, 400, 'toilet'),
(205, 2520, 300, 'toilet'),
(206, 2527, 300, 'toilet'),
(207, 2516, 300, 'toilet'),
(208, 2522, 300, 'toilet'),
(209, 2526, 300, 'toilet'),
(210, 1840, 200, 'electronic'),
(211, 2099, 250, 'electronic'),
(212, 2100, 250, 'electronic'),
(213, 2102, 200, 'electronic'),
(214, 2103, 200, 'electronic'),
(215, 2226, 250, 'electronic'),
(216, 2231, 200, 'electronic'),
(217, 2230, 200, 'electronic'),
(218, 2232, 200, 'electronic'),
(219, 2229, 200, 'electronic'),
(220, 2233, 250, 'electronic'),
(221, 1429, 200, 'electronic'),
(222, 2606, 250, 'electronic'),
(223, 1518, 200, 'electronic'),
(224, 1717, 200, 'electronic'),
(225, 1747, 200, 'electronic'),
(226, 1748, 200, 'electronic'),
(227, 1749, 200, 'electronic'),
(228, 1750, 200, 'electronic'),
(229, 1751, 200, 'electronic'),
(230, 1752, 200, 'electronic'),
(231, 1781, 150, 'electronic'),
(232, 1786, 200, 'electronic'),
(233, 1791, 200, 'electronic'),
(234, 1792, 200, 'electronic'),
(235, 2224, 400, 'electronic'),
(236, 2316, 200, 'electronic'),
(237, 2317, 200, 'electronic'),
(238, 2318, 200, 'electronic'),
(239, 2595, 200, 'electronic'),
(240, 2091, 300, 'electronic'),
(241, 2093, 300, 'electronic'),
(242, 2296, 450, 'electronic'),
(243, 2297, 400, 'electronic'),
(244, 14806, 400, 'electronic'),
(245, 1718, 100, 'electronic'),
(246, 1719, 100, 'electronic'),
(247, 1782, 100, 'electronic'),
(248, 1783, 100, 'electronic'),
(249, 1785, 100, 'electronic'),
(250, 1788, 100, 'electronic'),
(251, 1790, 100, 'electronic'),
(252, 1808, 150, 'electronic'),
(253, 1839, 150, 'electronic'),
(254, 2028, 100, 'electronic'),
(255, 2108, 150, 'electronic'),
(256, 2515, 150, 'toilet'),
(257, 2518, 150, 'toilet'),
(258, 2523, 150, 'toilet'),
(259, 2524, 150, 'toilet'),
(260, 2514, 200, 'toilet'),
(261, 2521, 150, 'toilet'),
(262, 2525, 150, 'toilet'),
(263, 2528, 200, 'toilet'),
(264, 2738, 150, 'toilet'),
(265, 2018, 250, 'toilet'),
(266, 1208, 250, 'toilet'),
(267, 2750, 100, 'toilet'),
(268, 2751, 30, 'toilet'),
(269, 2749, 30, 'toilet'),
(270, 2752, 30, 'toilet'),
(271, 2517, 400, 'toilet'),
(272, 2520, 300, 'toilet'),
(273, 2527, 300, 'toilet'),
(274, 2516, 300, 'toilet'),
(275, 2522, 300, 'toilet'),
(276, 2526, 300, 'toilet'),
(277, 1840, 200, 'electronic'),
(278, 2099, 250, 'electronic'),
(279, 2100, 250, 'electronic'),
(280, 2102, 200, 'electronic'),
(281, 2103, 200, 'electronic'),
(282, 2226, 250, 'electronic'),
(283, 2231, 200, 'electronic'),
(284, 2230, 200, 'electronic'),
(285, 2232, 200, 'electronic'),
(286, 2229, 200, 'electronic'),
(287, 2233, 250, 'electronic'),
(288, 1429, 200, 'electronic'),
(289, 2606, 250, 'electronic'),
(290, 1518, 200, 'electronic'),
(291, 1717, 200, 'electronic'),
(292, 1747, 200, 'electronic'),
(293, 1748, 200, 'electronic'),
(294, 1749, 200, 'electronic'),
(295, 1750, 200, 'electronic'),
(296, 1751, 200, 'electronic'),
(297, 1752, 200, 'electronic'),
(298, 1781, 150, 'electronic'),
(299, 1786, 200, 'electronic'),
(300, 1791, 200, 'electronic'),
(301, 1792, 200, 'electronic'),
(302, 2224, 400, 'electronic'),
(303, 2316, 200, 'electronic'),
(304, 2317, 200, 'electronic'),
(305, 2318, 200, 'electronic'),
(306, 2595, 200, 'electronic'),
(307, 2091, 300, 'electronic'),
(308, 2093, 300, 'electronic'),
(309, 2296, 450, 'electronic'),
(310, 2297, 400, 'electronic'),
(311, 14806, 400, 'electronic'),
(312, 1718, 100, 'electronic'),
(313, 1719, 100, 'electronic'),
(314, 1782, 100, 'electronic'),
(315, 1783, 100, 'electronic'),
(316, 1785, 100, 'electronic'),
(317, 1788, 100, 'electronic'),
(318, 1790, 100, 'electronic'),
(319, 1808, 150, 'electronic'),
(320, 1839, 150, 'electronic'),
(321, 2028, 100, 'electronic'),
(322, 2108, 150, 'electronic'),
(323, 2017, 250, 'electronic'),
(324, 2149, 150, 'electronic'),
(325, 2150, 150, 'electronic'),
(326, 2019, 150, 'wardrobe'),
(327, 2014, 200, 'wardrobe'),
(328, 2015, 200, 'wardrobe'),
(329, 2016, 200, 'wardrobe'),
(330, 2022, 250, 'wardrobe'),
(331, 2013, 250, 'wardrobe'),
(332, 2154, 200, 'wardrobe'),
(333, 2151, 200, 'wardrobe'),
(334, 2152, 200, 'wardrobe'),
(335, 2155, 200, 'wardrobe'),
(336, 2153, 200, 'wardrobe'),
(337, 2294, 200, 'wardrobe'),
(338, 2129, 200, 'wardrobe'),
(339, 2304, 250, 'wardrobe'),
(340, 2130, 250, 'wardrobe'),
(341, 2128, 250, 'wardrobe'),
(342, 2127, 250, 'wardrobe'),
(343, 2132, 250, 'wardrobe'),
(344, 2133, 200, 'wardrobe'),
(345, 2134, 200, 'wardrobe'),
(346, 2341, 200, 'wardrobe'),
(347, 2141, 200, 'wardrobe'),
(348, 2131, 200, 'wardrobe'),
(349, 2136, 250, 'wardrobe'),
(350, 2135, 200, 'wardrobe'),
(351, 2303, 200, 'wardrobe'),
(352, 2139, 200, 'wardrobe'),
(353, 2305, 200, 'wardrobe'),
(354, 2137, 200, 'wardrobe'),
(355, 2138, 200, 'wardrobe'),
(356, 2140, 200, 'wardrobe'),
(357, 2336, 250, 'wardrobe'),
(358, 2160, 250, 'wardrobe'),
(359, 2156, 250, 'wardrobe'),
(360, 2157, 250, 'wardrobe'),
(361, 2334, 250, 'wardrobe'),
(362, 2335, 250, 'wardrobe'),
(363, 2337, 250, 'wardrobe'),
(364, 2338, 250, 'wardrobe'),
(365, 2159, 250, 'wardrobe'),
(366, 2158, 250, 'wardrobe'),
(367, 2740, 100, 'lights'),
(368, 2707, 150, 'lights'),
(369, 2076, 150, 'lights'),
(370, 2075, 150, 'lights'),
(371, 2074, 150, 'lights'),
(372, 2073, 150, 'lights'),
(373, 2026, 150, 'lights'),
(374, 1734, 150, 'lights'),
(375, 1731, 150, 'lights'),
(376, 2238, 200, 'lights'),
(377, 2196, 150, 'lights'),
(378, 2176, 200, 'lights'),
(379, 2108, 150, 'lights'),
(380, 2107, 150, 'lights'),
(381, 2106, 150, 'lights'),
(382, 2105, 150, 'lights'),
(383, 2077, 100, 'lights'),
(384, 2070, 150, 'lights'),
(385, 2069, 150, 'lights'),
(386, 2023, 150, 'lights');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_gangs`
--

CREATE TABLE `ms_gangs` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `owner` text NOT NULL,
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `leaders` text NOT NULL,
  `members` text NOT NULL,
  `ann` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `website` varchar(100) NOT NULL DEFAULT 'brak',
  `tag` varchar(4) NOT NULL,
  `color` varchar(40) NOT NULL,
  `exp` int(11) NOT NULL DEFAULT '0',
  `totalexp` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `won_wars` int(6) NOT NULL,
  `lost_wars` int(6) NOT NULL,
  `ranks` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `logo` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_gangs_areas`
--

CREATE TABLE `ms_gangs_areas` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `w` float NOT NULL,
  `h` float NOT NULL,
  `r` int(3) NOT NULL,
  `g` int(3) NOT NULL,
  `b` int(3) NOT NULL,
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_gangs_bases`
--

CREATE TABLE `ms_gangs_bases` (
  `id` smallint(6) NOT NULL,
  `description` text NOT NULL,
  `text` varchar(250) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '[ { "x": 0, "y": 0, "z": 0 } ]',
  `radararea` varchar(200) NOT NULL DEFAULT '[ { "x": 0, "y": 0, "w": 0, "h": 0 } ]',
  `gangarea` varchar(200) NOT NULL DEFAULT '[ { "x": 0, "y": 0, "z": 0, "radius": 0 } ]',
  `owner` int(11) NOT NULL,
  `price_diamonds` int(5) NOT NULL,
  `price_dollars` int(9) NOT NULL,
  `pickup` varchar(200) NOT NULL DEFAULT '	[ { "x": 0, "y": 0, "z": 0 } ]',
  `gates` varchar(200) NOT NULL DEFAULT '[[ ]]',
  `expires` int(11) NOT NULL DEFAULT '-1',
  `antitheft` int(1) NOT NULL DEFAULT '0',
  `airprotection` varchar(100) NOT NULL DEFAULT '[ { "installed" : false  } ]'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_gangs_bases`
--

INSERT INTO `ms_gangs_bases` (`id`, `description`, `text`, `radararea`, `gangarea`, `owner`, `price_diamonds`, `price_dollars`, `pickup`, `gates`, `expires`, `antitheft`, `airprotection`) VALUES
(1, 'baza gangu na pustynii', '[ { \"x\": -300.43, \"y\": 1491.28, \"z\": 86 } ]', '[ { \"x\": -417, \"y\": 1502, \"w\": 171, \"h\": 144 } ]', '[ { \"x\": -334.07, \"y\": 1552.33, \"z\": 75.56, \"radius\": 100 } ]', 9, 1000, 180000, '[ { \"x\": -312.89, \"y\": 1505, \"z\": 75.6 } ]', '[[ {  \"x\": -301.4, \"y\": 1492.79, \"z\": 76.8, \"rx\": 0, \"ry\": 0, \"rz\": 5} ]]', 1491155523, 0, '[ { \"installed\": false, \"x\": -334.07, \"y\": 1552.33, \"z\": 100 } ]'),
(2, 'baza gangu w LS', '[ { \"x\": 1951.38, \"y\": -791.23, \"z\": 152.79 } ]', '[ { \"x\": 1861, \"y\": -914, \"w\": 231, \"h\": 225 } ]', '[ { \"x\": 1997.72, \"y\": -776.29, \"z\": 138.45, \"radius\": 200 } ]', 10, 1100, 200000, '[ { \"x\": 1968.12, \"y\": -799.16, \"z\": 138.45 } ]', '[[ {  \"x\": 1953.55, \"y\": -790.15, \"z\": 143, \"rx\": 0, \"ry\": 0, \"rz\": 288} ]]', 1489356985, 0, '[ { \"installed\": false, \"x\": 2045.6, \"y\": -752.52, \"z\": 150 } ]'),
(3, 'baza gangu w LV\r\n', '[ { \"x\": 2798.16, \"y\": 1313.37, \"z\": 16 } ]', '[ { \"x\": 2750, \"y\": 1220, \"w\": 121, \"h\": 166 } ]', '[ { \"x\": 2820.12, \"y\": 1307.44, \"z\": 10.96, \"radius\": 200 } ]', -1, 1000, 180000, '[ { \"x\": 2799.44, \"y\": 1302.47, \"z\": 10.90 } ]', '[[ {  \"x\": 2798.16, \"y\": 1313.37, \"z\": 12, \"rx\": 0, \"ry\": 0, \"rz\": 270} ]]', 0, 0, '[ { \"installed\": false, \"x\": 2798.47, \"y\": 1250.97, \"z\": 40 } ]');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_gangs_tags`
--

CREATE TABLE `ms_gangs_tags` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rot` float NOT NULL,
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_gangs_tags`
--

INSERT INTO `ms_gangs_tags` (`id`, `x`, `y`, `z`, `rot`, `owner`) VALUES
(45, 2735.96, -2039.67, 13.2204, 7, 9),
(46, 2715.88, -1823.65, 11.8438, 333, 12),
(47, 2747.51, -1646.11, 13.2281, 272, 12),
(48, 2704.83, -1497.88, 30.6036, 357, 9),
(49, 2711.76, -1327.39, 48.8179, 355, 9),
(50, 2680.71, -1099.74, 69.3208, 94, 9),
(51, 2421.74, -1189.57, 34.2007, 168, 9),
(52, 2372.33, -1393.99, 24.0034, 180, 9),
(53, 2402.71, -1551.7, 28, 180, 12),
(54, 2469.79, -1702.45, 13.517, 93, 12),
(55, 2438.43, -1896.09, 13.5534, 87, 12),
(56, 2522.38, -2132.57, 17.2712, 356, 9),
(57, 2139.42, -1182.72, 23.9922, 87, 9),
(58, 2157.24, -1323.96, 23.9909, 88, 9),
(59, 2115.01, -1497.37, 10.4219, 341, 9),
(60, 2148.6, -1729.37, 13.5416, 179, 9),
(61, 2175.1, -1907.29, 13.4994, 88, 9),
(62, 2088.91, -2079.65, 13.5469, 357, 9),
(63, 1808.56, -1116.14, 24.0781, 91, 9),
(64, 1822.95, -1314.71, 13.5653, 1, 9),
(65, 1815.61, -1556.2, 13.483, 68, 9),
(66, 1838.89, -1761.95, 13.5469, 175, 9),
(67, 1763.95, -1906.76, 13.5676, 182, 9),
(68, 1847.03, -2106.39, 13.5469, 179, 9),
(69, 1564.4, -2109.66, 16.0394, 199, 9),
(70, 1520.28, -1886.1, 13.6938, 89, 9),
(71, 1555.5, -1675.74, 16.1953, 268, 9),
(72, 1550.86, -1470.28, 13.5484, 2, 9),
(73, 1593.1, -1265.75, 17.4672, 88, 9),
(74, 1500.87, -1102.57, 25.0608, 357, 9),
(75, 1465.83, -925.885, 37.8691, 359, 9),
(76, 1196.55, -957.703, 42.9137, 191, 9),
(77, 1140.65, -1158.61, 23.8281, 178, 9),
(78, 1186.18, -1373.32, 13.5711, 90, 9),
(79, 1247.98, -1559.94, 13.5634, 357, 9),
(80, 1209.63, -1752.22, 13.5937, 223, 9),
(81, 1247.88, -1941.3, 30.6082, 132, 9),
(82, 1103.72, -2046.75, 69.0078, 1, 9),
(83, 987.316, -1643.09, 14.8255, 178, 9),
(84, 981.955, -1520.13, 13.5493, 358, 9),
(85, 956.13, -1270.22, 15.4049, 358, 9),
(86, 862.913, -1080.37, 24.2969, 0, 9),
(87, 952.527, -909.167, 45.7656, 2, 9),
(88, 674.63, -1198.49, 17.2266, 221, 9),
(89, 649.309, -1356.71, 13.5639, 267, 9),
(90, 654.186, -1541.74, 14.8516, 1, 9),
(91, 645.58, -1764.87, 12.9633, 77, 9),
(92, 343.623, -1631.88, 33.2713, 270, 9),
(93, 427.525, -1440.99, 31.091, 294, 9),
(94, 364.211, -1337.41, 14.5201, 110, 9),
(95, 408.583, -1141.42, 76.6438, 240, 9);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_houses`
--

CREATE TABLE `ms_houses` (
  `id` int(11) NOT NULL,
  `interiorid` int(11) NOT NULL DEFAULT '1',
  `enterX` float NOT NULL,
  `enterY` float NOT NULL,
  `enterZ` float NOT NULL,
  `name` text NOT NULL,
  `price` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL,
  `ownerName` text NOT NULL,
  `roommates` varchar(300) NOT NULL DEFAULT '[ [ ] ]',
  `locked` int(1) NOT NULL DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `ms_houses`
--

INSERT INTO `ms_houses` (`id`, `interiorid`, `enterX`, `enterY`, `enterZ`, `name`, `price`, `owner`, `ownerName`, `roommates`, `locked`, `timestamp`) VALUES
(1, 3, 2523.85, -1658.69, 15.4935, 'Los Santos, Ganton', 15000, 2797, 'daxler', '[ [ ] ]', 0, 1520973102),
(2, 3, 2513.75, -1650.3, 14.3557, 'Los Santos, Ganton', 15000, 2799, 'Rivendell', '[ [ ] ]', 0, 1547302422),
(3, 3, 2498.62, -1643.04, 13.7826, 'Los Santos, Ganton', 15000, 2782, 'Grapa', '[ [ [ \"Luxanna\", 2808 ] ] ]', 0, 1547301701),
(4, 3, 2451.92, -1642.08, 13.7357, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(5, 3, 2408.95, -1674.01, 13.6036, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(6, 3, 2384.67, -1674.88, 14.7218, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(7, 3, 2368.18, -1675.3, 14.1682, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(8, 3, 2362.76, -1644.06, 13.5324, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(9, 3, 2393.16, -1646.04, 13.9051, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(10, 3, 2413.94, -1646.99, 14.0119, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(11, 2, 2486.42, -1645.12, 14.0772, 'Los Santos, Ganton', 25000, 2803, 'Nemezis', '[ [ ] ]', 0, 1520691267),
(12, 6, 2495.42, -1690.89, 14.7656, 'Los Santos, Ganton', 30000, 2803, 'Nemezis', '[ [ ] ]', 0, 1520691253),
(13, 2, 2459.53, -1691.09, 13.5443, 'Los Santos, Ganton', 25000, 2767, 'Szydlo', '[ [ ] ]', 0, 1524774512),
(14, 3, 2327.39, -1682.07, 14.9297, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(15, 3, 2307.09, -1678.25, 14.0012, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(16, 3, 2282.3, -1641.23, 15.8898, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(17, 3, 2257.05, -1643.93, 15.8082, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(18, 3, 2244.44, -1637.66, 16.2379, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(19, 3, 2385.34, -1711.66, 14.2422, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(20, 3, 2402.62, -1715.28, 14.1328, 'Los Santos, Ganton', 15000, -1, '', '[ [ ] ]', 0, 0),
(21, 8, 2586.8, -1200.07, 59.2188, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(22, 8, 2587.29, -1203.2, 58.576, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(23, 8, 2587.4, -1207.69, 57.6515, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(24, 8, 2587.39, -1211.77, 56.5144, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(25, 8, 2587.39, -1216.41, 55.1144, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(26, 8, 2587.4, -1220.47, 53.7654, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(27, 8, 2587.39, -1224.77, 52.4771, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(28, 8, 2587.4, -1229.16, 51.1906, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(29, 8, 2587.4, -1233.59, 49.9621, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(30, 8, 2587.4, -1238.16, 48.5644, 'Los Santos, Los Flores', 5000, -1, '', '[ [ ] ]', 0, 0),
(31, 8, 2601.05, -1200.18, 59.5017, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(32, 8, 2601.05, -1203, 58.7274, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(33, 8, 2601.05, -1207.65, 57.7933, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(34, 8, 2601.04, -1211.76, 56.6573, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(35, 8, 2601.04, -1216.3, 55.2692, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(36, 8, 2601.04, -1220.59, 53.9187, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(37, 8, 2601.05, -1224.66, 52.6275, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(38, 8, 2601.05, -1229.37, 51.3422, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(39, 8, 2601.05, -1233.58, 50.1126, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(40, 8, 2601.05, -1238.02, 48.7154, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(41, 8, 2608.16, -1238.02, 50.2064, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(42, 8, 2608.18, -1233.39, 51.6089, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(43, 8, 2608.2, -1229.11, 52.842, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(44, 8, 2608.15, -1224.63, 54.1183, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(45, 8, 2608.16, -1220.38, 55.4121, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(46, 8, 2608.16, -1216.31, 56.7618, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(47, 8, 2608.15, -1211.73, 58.1499, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(48, 8, 2608.15, -1207.5, 59.2834, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(49, 8, 2608.16, -1202.97, 60.2183, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(50, 8, 2608.15, -1200.02, 60.992, 'Los Santos, Los Flores', 5000, -1, '', '[ [ ] ]', 0, 0),
(51, 8, 2615.11, -1200.17, 60.7812, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(52, 8, 2615.1, -1203.1, 60, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(53, 8, 2615.11, -1207.47, 59.0703, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(54, 8, 2615.11, -1211.93, 57.9375, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(55, 8, 2615.11, -1216.43, 56.5391, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(56, 8, 2615.11, -1220.55, 55.1875, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(57, 8, 2615.11, -1224.7, 53.8984, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(58, 8, 2615.1, -1229.38, 52.6094, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(59, 8, 2615.09, -1233.68, 51.3828, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(60, 8, 2615.1, -1238.2, 49.9844, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(61, 8, 2622.24, -1237.95, 51.2736, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(62, 8, 2622.28, -1233.51, 52.6797, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(63, 8, 2622.22, -1229.34, 53.8968, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(64, 8, 2622.22, -1224.68, 55.1807, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(65, 8, 2622.22, -1220.55, 56.4742, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(66, 8, 2622.21, -1216.23, 57.8227, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(67, 8, 2622.25, -1211.76, 59.2188, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(68, 8, 2622.23, -1207.66, 60.3498, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(69, 8, 2622.22, -1203.2, 61.2808, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(70, 8, 2622.24, -1200.08, 62.0589, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(71, 8, 2663.17, -1238.02, 55.6738, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(72, 8, 2663.18, -1233.54, 57.0715, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(73, 8, 2663.13, -1229.15, 58.3, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(74, 8, 2663.16, -1224.68, 59.5865, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(75, 8, 2663.17, -1220.45, 60.8748, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(76, 8, 2663.18, -1216.2, 62.2237, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(77, 8, 2663.15, -1211.77, 63.6238, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(78, 8, 2663, -1207.7, 64.7609, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(79, 8, 2663, -1203.15, 65.6854, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(80, 8, 2663.17, -1200.23, 66.4672, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(81, 8, 2670.28, -1200.09, 66.4914, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(82, 8, 2670.33, -1203.19, 65.7175, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(83, 8, 2670.31, -1207.68, 64.7945, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(84, 8, 2670.29, -1211.72, 63.6707, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(85, 8, 2670.29, -1216.21, 62.2786, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(86, 8, 2670.29, -1220.54, 60.9192, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(87, 8, 2670.29, -1224.71, 59.6328, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(88, 8, 2670.3, -1229.36, 58.345, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(89, 8, 2670.28, -1233.56, 57.1172, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(90, 8, 2670.28, -1238.22, 55.7148, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(91, 8, 2683.44, -1238.22, 56.0199, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(92, 8, 2683.44, -1233.61, 57.4173, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(93, 8, 2683.38, -1229.37, 58.6336, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(94, 8, 2683.44, -1224.65, 59.9319, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(95, 8, 2683.42, -1220.55, 61.2216, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(96, 8, 2683.43, -1216.2, 62.5721, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(97, 8, 2683.43, -1211.65, 63.9629, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(98, 8, 2683.43, -1207.64, 65.0956, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(99, 8, 2683.44, -1203.14, 66.0315, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(100, 8, 2683.44, -1199.95, 66.8065, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(101, 8, 2690.55, -1200, 68.2989, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(102, 8, 2690.58, -1203.01, 67.531, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(103, 8, 2690.56, -1207.65, 66.5928, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(104, 8, 2690.56, -1211.94, 65.4579, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(105, 8, 2690.54, -1216.51, 64.0655, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(106, 8, 2690.54, -1220.44, 62.7164, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(107, 8, 2690.54, -1224.85, 61.423, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(108, 8, 2690.54, -1229.45, 60.1368, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(109, 8, 2690.59, -1233.32, 58.9181, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(110, 8, 2690.54, -1238.24, 57.5105, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(111, 8, 2700.19, -1238.15, 58.1799, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(112, 8, 2700.2, -1233.54, 59.5795, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(113, 8, 2700.18, -1229.47, 60.8063, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(114, 8, 2700.2, -1224.69, 62.0953, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(115, 8, 2700.2, -1220.5, 63.3876, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(116, 8, 2700.2, -1216.26, 64.7378, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(117, 8, 2700.2, -1211.9, 66.1274, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(118, 8, 2700.2, -1207.69, 67.261, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(119, 8, 2700.19, -1203.18, 68.1931, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(120, 8, 2700.2, -1200.22, 68.9692, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(121, 8, 2707.34, -1199.86, 70.4671, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(122, 8, 2707.33, -1203.25, 69.6903, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(123, 8, 2707.31, -1207.57, 68.7521, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(124, 8, 2707.32, -1211.88, 67.6202, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(125, 8, 2707.31, -1216.26, 66.23, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(126, 8, 2707.31, -1220.62, 64.8803, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(127, 8, 2707.41, -1224.44, 63.6075, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(128, 8, 2707.31, -1229.29, 62.3013, 'Los Santos, Los Flores', 5000, -1, '', '[ [ ] ]', 0, 0),
(129, 8, 2707.32, -1233.34, 61.0742, 'Los Santos, Los Flores', 5000, -1, '', '[[ ]]', 0, 0),
(130, 8, 2707.32, -1237.98, 59.6765, 'Los Santos, Los Flores', 5000, -1, '', '[ [ ] ]', 0, 0),
(131, 8, 2495.51, -1431.68, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(132, 8, 2492.13, -1431.68, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(133, 8, 2487.24, -1431.69, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(134, 8, 2476.37, -1431.94, 28.8482, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(135, 8, 2473.12, -1431.69, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(136, 8, 2468.33, -1431.69, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(137, 8, 2468.16, -1424.58, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(138, 8, 2473.09, -1424.57, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(139, 8, 2476.52, -1424.57, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(140, 8, 2487.38, -1424.57, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(141, 8, 2492.2, -1424.57, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(142, 8, 2495.22, -1424.58, 29.0162, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(143, 8, 2495.42, -1417.45, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(144, 8, 2492.26, -1417.45, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(145, 8, 2487.33, -1417.44, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(146, 8, 2476.41, -1417.45, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(147, 8, 2473.1, -1417.45, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(148, 8, 2468.44, -1417.46, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(149, 8, 2468.35, -1410.33, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(150, 8, 2473.23, -1410.34, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(151, 8, 2476.35, -1410.33, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(152, 8, 2487.2, -1410.34, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(153, 8, 2492.18, -1410.34, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(154, 8, 2495.19, -1410.34, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(155, 8, 2495.38, -1398.81, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(156, 8, 2492.31, -1398.82, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(157, 8, 2487.33, -1398.82, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(158, 8, 2476.49, -1398.81, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(159, 8, 2473.15, -1398.81, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(160, 8, 2468.3, -1398.81, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(161, 8, 2468.27, -1391.71, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(162, 8, 2472.98, -1391.71, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(163, 8, 2476.36, -1391.7, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(164, 8, 2487.4, -1391.69, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(165, 8, 2492, -1391.7, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(166, 8, 2495.46, -1391.71, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(167, 8, 2495.37, -1383.38, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(168, 8, 2492.13, -1383.38, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(169, 8, 2487.42, -1383.38, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(170, 8, 2476.38, -1383.38, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(171, 8, 2473.31, -1383.37, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(172, 8, 2468.46, -1383.38, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(173, 8, 2476.12, -1376.26, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(174, 8, 2473.04, -1376.27, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(175, 8, 2468.14, -1376.27, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(176, 8, 2487.27, -1376.27, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(177, 8, 2492.11, -1376.27, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(178, 8, 2495.18, -1376.27, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(179, 8, 2495.46, -1366.2, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(180, 8, 2492.21, -1366.21, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(181, 8, 2487.31, -1366.21, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(182, 8, 2476.29, -1366.21, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(183, 8, 2473, -1366.21, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(184, 8, 2468.35, -1366.2, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(185, 8, 2468.41, -1359.09, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(186, 8, 2473.15, -1359.1, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(187, 8, 2476.45, -1359.1, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(188, 8, 2487.19, -1359.09, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(189, 8, 2492.25, -1359.1, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(190, 8, 2495.4, -1359.1, 29.3131, 'Los Santos, East Los Santos', 5000, -1, '', '[[ ]]', 0, 0),
(191, 3, 2250.02, -1238.9, 25.8984, 'Los Santos, Jefferson', 15000, 2791, 'Riders', '[ [ ] ]', 1, 1521744506),
(192, 3, 2229.53, -1241.6, 25.6562, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(193, 3, 2209.85, -1240.23, 24.4801, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(194, 3, 2191.71, -1239.23, 24.4879, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(195, 3, 2153.79, -1243.79, 25.3672, 'Los Santos, Jefferson', 15000, 2778, '.MasTex', '[ [ ] ]', 0, 1526294054),
(196, 3, 2133.44, -1232.99, 24.4219, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(197, 3, 2110.79, -1244.38, 25.8516, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(198, 3, 2090.93, -1235.17, 26.0191, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(199, 3, 2091, -1277.83, 26.1797, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(200, 3, 2111.53, -1278.99, 25.8359, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(201, 3, 2132.2, -1280.05, 25.8906, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(202, 3, 2150.23, -1285.05, 24.5269, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(203, 3, 2148.52, -1320.08, 26.0738, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(204, 4, 2126.58, -1320.87, 26.624, 'Los Santos, Jefferson', 20000, -1, '', '[ [ ] ]', 0, 0),
(205, 3, 2100.98, -1321.89, 25.9531, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(206, 3, 2191.66, -1275.6, 25.1562, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(207, 3, 2208.11, -1280.86, 25.1207, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(208, 3, 2230.02, -1280.07, 25.6285, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(209, 3, 2250.42, -1280.32, 25.4766, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(210, 3, 2129.53, -1361.71, 26.1363, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(211, 3, 2147.68, -1366.14, 25.9723, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(212, 3, 2151.17, -1400.51, 26.1285, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(213, 3, 2150.92, -1418.95, 25.9219, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(214, 3, 2149.85, -1433.82, 26.0703, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(215, 3, 2152.21, -1446.54, 26.1051, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(216, 3, 2146.8, -1470.25, 26.0426, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(217, 4, 2148.92, -1484.96, 26.624, 'Los Santos, Jefferson', 20000, -1, '', '[ [ ] ]', 0, 0),
(218, 3, 2185.21, -1363.71, 26.1598, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(219, 3, 2202.67, -1363.68, 26.191, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(220, 3, 2230.63, -1397.23, 24.5738, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(221, 3, 2243.43, -1397.24, 24.5738, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(222, 3, 2256.37, -1397.24, 24.5738, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(223, 3, 2263.73, -1469.34, 24.3707, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(224, 3, 2247.88, -1469.33, 24.4801, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(225, 3, 2232.65, -1469.38, 24.5816, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(226, 3, 2190.32, -1487.52, 26.1051, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(227, 3, 2190.45, -1470.16, 25.9141, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(228, 3, 2191.17, -1456.05, 26, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(229, 3, 2194.42, -1442.99, 26.0738, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(230, 3, 2188.59, -1419.34, 26.1562, 'Los Santos, Jefferson', 15000, -1, '', '[ [ ] ]', 0, 0),
(231, 3, 2196.23, -1404.16, 25.9488, 'Los Santos, Jefferson', 15000, -1, '', '[[ ]]', 0, 0),
(232, 6, 1241.95, -1076.75, 31.5547, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(233, 6, 1242.27, -1099.96, 27.9766, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(234, 6, 1285.04, -1090.39, 28.2578, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(235, 6, 1285.14, -1066.78, 31.6789, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(236, 6, 1183.47, -1075.3, 31.6789, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(237, 6, 1142.03, -1069.52, 31.7656, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(238, 6, 1142.15, -1093.56, 28.1875, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(239, 6, 1183.21, -1098.99, 28.2578, 'Los Santos, Temple', 30000, -1, '', '[ [ ] ]', 0, 0),
(240, 2, 766.904, -1605.71, 13.8039, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(241, 2, 767.864, -1655.69, 5.60938, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(242, 2, 769.175, -1696.54, 5.15542, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(243, 2, 769.07, -1745.88, 13.0773, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(244, 2, 791.678, -1753.22, 13.4603, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(245, 2, 797.247, -1729.1, 13.5469, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(246, 2, 793.997, -1707.59, 14.0382, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(247, 2, 794.899, -1692.1, 14.4633, 'Los Santos, Marina', 25000, -1, '', '[[ ]]', 0, 0),
(248, 2, 790.537, -1661.15, 13.4825, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(249, 2, 693.556, -1705.6, 3.81948, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(250, 2, 694.872, -1690.73, 4.34612, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(251, 2, 693.756, -1645.96, 4.09375, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(252, 2, 697.28, -1627.14, 3.74917, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(253, 2, 693.087, -1602.77, 15.0469, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(254, 2, 653.244, -1619.77, 15, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(255, 2, 660.548, -1599.85, 15, 'Los Santos, Marina', 25000, -1, '', '[[ ]]', 0, 0),
(256, 2, 656.155, -1635.87, 15.8617, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(257, 2, 657.224, -1653.01, 15.4062, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(258, 2, 653.592, -1713.98, 14.7648, 'Los Santos, Marina', 25000, -1, '', '[ [ ] ]', 0, 0),
(259, 2, 315.993, -1769.44, 4.62417, 'Los Santos, Santa Maria Beach', 25000, 2791, 'Riders', '[ [ [ \"kozak\", 2792 ] ] ]', 0, 1530212678),
(262, 3, 2065.14, -1703.66, 14.1484, 'Los Santos, Idlewood', 15000, -1, '', '[ [ ] ]', 0, 0),
(263, 14, 254.529, -1367.21, 53.1094, 'Los Santos, Richman', 50000, 2805, 'Bartx.', '[ [ ] ]', 0, 1526818388),
(264, 20, 253.19, -1270.01, 74.4306, 'Los Santos, Richman', 150000, -1, '', '[ [ ] ]', 0, 0),
(265, 20, 251.341, -1220.28, 76.1024, 'Los Santos, Richman', 150000, -1, '', '[ [ ] ]', 0, 0),
(266, 20, 300.101, -1154.31, 81.3894, 'Los Santos, Richman', 250000, 530, 'Kacperek81', '[ [ ] ]', 0, 1520959337),
(267, 20, 189.637, -1308.08, 70.2494, 'Los Santos, Richman', 150000, -1, '', '[ [ ] ]', 0, 0),
(268, 14, 211.337, -1238.88, 78.3504, 'Los Santos, Richman', 50000, -1, '', '[ [ ] ]', 0, 0),
(269, 14, 836.191, -894.566, 68.7689, 'Los Santos, Mulholland', 50000, -1, '', '[ [ ] ]', 0, 0),
(270, 12, 1298.42, -797.982, 84.1406, 'Los Santos, Mulholland', 350000, 2798, 'grabson', '[ [ ] ]', 0, 1522071851),
(271, 20, 1497.03, -687.965, 95.5633, 'Red County, Mulholland', 150000, -1, '', '[ [ ] ]', 0, 0),
(272, 14, 1332.12, -633.502, 109.135, 'Red County, Mulholland', 50000, -1, '', '[ [ ] ]', 0, 0),
(273, 14, 1095.05, -647.91, 113.648, 'Red County, Red County', 50000, -1, '', '[ [ ] ]', 0, 0),
(274, 14, 1045.08, -642.951, 120.117, 'Red County, Red County', 50000, -1, '', '[ [ ] ]', 0, 0),
(275, 1, 2324.76, 191.052, 28.4416, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(276, 2, 2363.13, 187.327, 28.4416, 'Red County, Palomino Creek', 15000, -1, '', '[[ ]]', 0, 0),
(277, 20, 980.474, -677.271, 121.976, 'Red County, Red County', 150000, -1, '', '[ [ ] ]', 0, 0),
(278, 3, 2363, 166.213, 28.4416, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(279, 4, 2324.63, 162.184, 28.4416, 'Red County, Palomino Creek', 13000, -1, '', '[[ ]]', 0, 0),
(280, 5, 2363.12, 142.064, 28.4416, 'Red County, Palomino Creek', 15000, -1, '', '[[ ]]', 0, 0),
(281, 7, 2324.49, 136.327, 28.4416, 'Red County, Palomino Creek', 15000, -1, '', '[ [ ] ]', 0, 0),
(282, 8, 2324.89, 116.067, 28.4416, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(283, 9, 2363.39, 116.348, 28.4416, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(284, 14, 891.303, -783.108, 101.314, 'Los Santos, Mulholland', 50000, -1, '', '[ [ ] ]', 0, 0),
(285, 1, 2438.71, -53.7109, 28.1535, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(286, 2, 2415.46, -51.5537, 28.1535, 'Red County, Palomino Creek', 15000, -1, '', '[[ ]]', 0, 0),
(287, 3, 2392.27, -54.0527, 28.1536, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(288, 8, 2367.33, -48.2178, 28.1535, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(289, 1, 2322.45, -124.077, 28.1536, 'Red County, Palomino Creek', 10000, -1, '', '[ [ ] ]', 0, 0),
(290, 3, 2293.91, -124.15, 28.1535, 'Red County, Palomino Creek', 10000, -1, '', '[ [ ] ]', 0, 0),
(291, 4, 2272.44, -118.156, 28.1535, 'Red County, Palomino Creek', 13000, -1, '', '[ [ ] ]', 0, 0),
(292, 5, 2245.49, -121.084, 28.1535, 'Red County, Palomino Creek', 15000, -1, '', '[ [ ] ]', 0, 0),
(293, 8, 2204.02, -89.3115, 28.1535, 'Red County, Palomino Creek', 10000, -1, '', '[ [ ] ]', 0, 0),
(294, 11, 2198.6, -60.748, 28.1535, 'Red County, Palomino Creek', 10000, -1, '', '[[ ]]', 0, 0),
(295, 15, 2200.96, -37.4316, 28.1535, 'Red County, Palomino Creek', 15000, -1, '', '[ [ ] ]', 0, 0),
(296, 1, 295.033, -55.1543, 2.77721, 'Red County, Blueberry', 10000, -1, '', '[[ ]]', 0, 0),
(297, 18, 267.48, -55.4258, 2.77721, 'Red County, Blueberry', 8000, -1, '', '[[ ]]', 0, 0),
(298, 1, 251.771, -92.252, 3.53539, 'Red County, Blueberry', 10000, -1, '', '[[ ]]', 0, 0),
(299, 2, 251.966, -121.286, 3.53539, 'Red County, Blueberry', 15000, -1, '', '[[ ]]', 0, 0),
(300, 17, 1316.04, 2524.52, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[ [ ] ]', 0, 0),
(301, 4, 313.568, -92.5947, 3.53539, 'Red County, Blueberry', 13000, -1, '', '[[ ]]', 0, 0),
(302, 17, 1274.19, 2522.5, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(303, 7, 313.688, -121.311, 3.53539, 'Red County, Blueberry', 15000, -1, '', '[[ ]]', 0, 0),
(304, 17, 1269.63, 2554.36, 10.8265, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(305, 17, 1271.89, 2564.37, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(306, 17, 1325.54, 2567.35, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(307, 17, 1349.69, 2567.69, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(308, 17, 1359.95, 2565.61, 10.8265, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(309, 17, 1417.83, 2567.65, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(310, 17, 1441.67, 2567.85, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(311, 17, 1451.51, 2565.63, 10.8265, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(312, 17, 1503.25, 2567.69, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(313, 17, 1513.36, 2565.58, 10.8265, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(314, 17, 1551.41, 2567.34, 10.8203, 'Las Venturas, Julius Thruway North', 25000, -1, '', '[[ ]]', 0, 0),
(315, 17, 1564.63, 2565.44, 10.8265, 'Las Venturas, Julius Thruway North', 25000, -1, '', '[[ ]]', 0, 0),
(316, 17, 1596.5, 2567.83, 10.8203, 'Las Venturas, Julius Thruway North', 25000, -1, '', '[[ ]]', 0, 0),
(317, 1, -2219.75, -2400.45, 32.5823, 'Whetstone, Angel Pine', 10000, -1, '', '[[ ]]', 0, 0),
(318, 17, 1623.43, 2567.34, 10.8203, 'Las Venturas, Julius Thruway North', 25000, -1, '', '[[ ]]', 0, 0),
(319, 2, -2238.63, -2424.2, 32.7073, 'Whetstone, Angel Pine', 15000, -1, '', '[[ ]]', 0, 0),
(320, 5, -2214.53, -2451.2, 31.8163, 'Whetstone, Angel Pine', 15000, -1, '', '[[ ]]', 0, 0),
(321, 8, -2227.69, -2489.38, 31.8163, 'Whetstone, Angel Pine', 10000, -1, '', '[[ ]]', 0, 0),
(322, 17, 1611.77, 2648.24, 10.8265, 'Las Venturas, Prickle Pine', 25000, -1, '', '[ [ ] ]', 0, 0),
(323, 9, -2192.62, -2509.93, 31.8163, 'Whetstone, Angel Pine', 10000, -1, '', '[[ ]]', 0, 0),
(324, 21, 1456.13, 2773.5, 10.8203, 'Las Venturas, Yellow Bell Golf Course', 400000, -1, '', '[ [ ] ]', 0, 0),
(325, 1, -2160.89, -2534.71, 31.8163, 'Whetstone, Angel Pine', 10000, -1, '', '[ [ ] ]', 0, 0),
(326, 2, -2132.16, -2511.54, 31.8163, 'Whetstone, Angel Pine', 15000, -1, '', '[ [ ] ]', 0, 0),
(327, 17, 1225.28, 2584.73, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(328, 17, 1223.02, 2616.77, 10.8265, 'Las Venturas, Prickle Pine', 25000, 2790, 'Mysterek', '[[ ]]', 0, 1520534900),
(329, 1, -44.9805, 1081.67, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(330, 2, 0.75, 1076.01, 20.9399, 'Bone County, Fort Carson', 15000, -1, '', '[[ ]]', 0, 0),
(331, 4, 1265.5, 2610.03, 10.8203, 'Las Venturas, Prickle Pine', 15000, -1, '', '[ [ ] ]', 0, 0),
(332, 4, 1284.74, 2610.72, 10.8203, 'Las Venturas, Prickle Pine', 15000, -1, '', '[[ ]]', 0, 0),
(333, 15, -258.89, 1083.77, 20.9399, 'Bone County, Fort Carson', 15000, -1, '', '[[ ]]', 0, 0),
(334, 11, -298.277, 1114.96, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(335, 7, -328.881, 1119.17, 20.9399, 'Bone County, Fort Carson', 15000, -1, '', '[ [ ] ]', 0, 0),
(336, 20, 1313.77, 2610.19, 11.2989, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(337, 4, -362.371, 1110.74, 20.9399, 'Bone County, Fort Carson', 13000, -1, '', '[[ ]]', 0, 0),
(338, 13, 1344.64, 2610.19, 11.2989, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(339, 17, -368.912, 1168.76, 20.2719, 'Bone County, Fort Carson', 25000, -1, '', '[ [ ] ]', 0, 0),
(340, 11, -360.2, 1141.7, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(341, 1, -259.515, 1169.04, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(342, 4, -258.937, 1151.19, 20.9399, 'Bone County, Fort Carson', 13000, -1, '', '[[ ]]', 0, 0),
(343, 8, -261.045, 1120.02, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(344, 17, 1570.27, 2711.11, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(345, 17, 1580.09, 2708.85, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(346, 17, 1601.18, 2709.01, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(347, 17, 1627.13, 2710.76, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(348, 9, -36.2256, 1114.43, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[[ ]]', 0, 0),
(349, 17, 1652.42, 2708.85, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(350, 11, -18.2852, 1114.83, 20.9399, 'Bone County, Fort Carson', 10000, -1, '', '[ [ ] ]', 0, 0),
(351, 18, 12.7422, 1112.98, 20.9399, 'Bone County, Fort Carson', 8000, -1, '', '[ [ ] ]', 0, 0),
(352, 13, 1663.23, 2754.14, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(353, 13, 1643.75, 2753.29, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(354, 13, 1626.77, 2754.14, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(355, 13, 1608.68, 2753.94, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(356, 17, 1599.39, 2757.6, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(357, 13, 1565.45, 2757.07, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(358, 13, 1564.78, 2776.68, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(359, 13, 1565.47, 2793.39, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(360, 17, 1550.57, 2846.08, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(361, 17, 1575.82, 2843.96, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(362, 17, 1601.79, 2846.07, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[ [ ] ]', 0, 0),
(363, 17, -2437.45, 2354.82, 5.44307, 'Tierra Robada, Bayside', 25000, -1, '', '[[ ]]', 0, 0),
(364, 17, 1622.74, 2846.08, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(365, 17, 1632.74, 2843.81, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(366, 17, 1664.72, 2846.08, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(368, 17, 1588.51, 2797.33, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[ [ ] ]', 0, 0),
(369, 13, 1618.31, 2800.79, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(370, 9, -1499.91, 1960.94, 49.0234, 'Tierra Robada, Tierra Robada', 10000, -1, '', '[ [ ] ]', 0, 0),
(371, 13, 1637.8, 2801.48, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(372, 13, 1654.92, 2800.79, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(373, 13, 1673.14, 2800.93, 10.8203, 'Las Venturas, Prickle Pine', 25000, -1, '', '[[ ]]', 0, 0),
(374, 10, -2523.52, 2239.5, 5.38764, 'Tierra Robada, Bayside', 20000, -1, '', '[ [ ] ]', 0, 0),
(375, 17, -2551.96, 2266.83, 5.47552, 'Tierra Robada, Bayside', 25000, -1, '', '[ [ ] ]', 0, 0),
(376, 13, -2626.14, 2283.4, 8.30283, 'Tierra Robada, Bayside', 20000, -1, '', '[[ ]]', 0, 0),
(377, 16, -2626.14, 2291.89, 8.30284, 'Tierra Robada, Bayside', 30000, -1, '', '[[ ]]', 0, 0),
(378, 13, -2625.91, 2310.09, 8.30093, 'Tierra Robada, Bayside', 20000, -1, '', '[[ ]]', 0, 0),
(379, 16, -2626.73, 2318.6, 8.30756, 'Tierra Robada, Bayside', 30000, -1, '', '[[ ]]', 0, 0),
(380, 13, -2626.38, 2359.29, 8.91473, 'Tierra Robada, Bayside', 20000, -1, '', '[[ ]]', 0, 0),
(381, 16, -2634.84, 2402.88, 11.2639, 'Tierra Robada, Bayside', 30000, -1, '', '[[ ]]', 0, 0),
(382, 16, -2479.65, 2448.99, 17.323, 'Tierra Robada, Bayside', 30000, -1, '', '[ [ ] ]', 0, 0),
(383, 16, -2472.3, 2450.67, 17.323, 'Tierra Robada, Bayside', 30000, -1, '', '[[ ]]', 0, 0),
(384, 13, -2424.91, 2447.79, 13.1837, 'Tierra Robada, Bayside', 20000, -1, '', '[[ ]]', 0, 0),
(385, 13, -2386.88, 2446.47, 10.1694, 'Tierra Robada, Bayside', 20000, -1, '', '[[ ]]', 0, 0),
(386, 16, -2379.47, 2443.89, 10.1694, 'Tierra Robada, Bayside', 30000, -1, '', '[ [ ] ]', 0, 0),
(387, 13, -2348.82, 2422.77, 7.34405, 'Tierra Robada, Bayside Marina', 20000, -1, '', '[[ ]]', 0, 0),
(388, 21, -2719.35, -319.142, 7.84375, 'San Fierro, Avispa Country Club', 800000, 2789, 'Kuks*', '[ [ ] ]', 0, 1520531291),
(389, 9, -910.974, 2685.9, 42.3703, 'Tierra Robada, Valle Ocultado', 30000, -1, '', '[ [ ] ]', 0, 0),
(390, 8, 263.562, 2895.44, 10.5314, 'Bone County, Bone County', 20000, 2762, 'madvalue', '[ [ ] ]', 0, 1525984204),
(391, 6, -314.077, 1774.76, 43.6406, 'Bone County, Regular Tom', 30000, 2811, 'skneryp', '[ [ ] ]', 0, 1520957941),
(392, 3, -1051.72, 1550.06, 33.4376, 'Tierra Robada, Tierra Robada', 15000, -1, '', '[ [ ] ]', 0, 0),
(393, 3, -418.714, -1759.56, 6.21875, 'Flint County, Flint County', 10000, -1, '', '[ [ ] ]', 0, 0),
(394, 3, 870.235, -25.4287, 63.9513, 'Red County, Fern Ridge', 10000, -1, '', '[ [ ] ]', 0, 0),
(395, 18, -347.902, -1046.42, 59.8125, 'Flint County, Beacon Hill', 8000, -1, '', '[ [ ] ]', 0, 0),
(396, 15, 23.9766, -2646.54, 40.4638, 'Flint County, Flint County', 15000, -1, '', '[ [ ] ]', 0, 0),
(397, 14, -1872.77, -218.301, 18.375, 'San Fierro, Doherty', 50000, -1, '', '[ [ ] ]', 0, 0),
(398, 16, -2721.81, 924.006, 67.5938, 'San Fierro, Paradiso', 30000, -1, '', '[[ ]]', 0, 0),
(399, 10, -2706.69, 865.604, 70.7031, 'San Fierro, Paradiso', 20000, -1, '', '[[ ]]', 0, 0),
(400, 10, -2662.15, 877.327, 79.7738, 'San Fierro, Paradiso', 20000, -1, '', '[[ ]]', 0, 0),
(401, 13, -2641.19, 934.921, 71.9531, 'San Fierro, Paradiso', 20000, -1, '', '[[ ]]', 0, 0),
(402, 7, -2099.4, 898.283, 76.7109, 'San Fierro, Calton Heights', 15000, -1, '', '[ [ ] ]', 0, 0),
(403, 4, -2172.82, 680.001, 55.1624, 'San Fierro, Chinatown', 13000, -1, '', '[ [ ] ]', 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_logging`
--

CREATE TABLE `ms_logging` (
  `idx` int(11) NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '-1',
  `type` varchar(48) NOT NULL DEFAULT '?' COMMENT 'typ',
  `txt` text,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'czas'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_payments`
--

CREATE TABLE `ms_payments` (
  `uid` int(11) NOT NULL,
  `count` int(9) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `platform` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_players`
--

CREATE TABLE `ms_players` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `exp` int(11) NOT NULL DEFAULT '0',
  `totalexp` int(11) NOT NULL DEFAULT '0',
  `level` int(4) NOT NULL DEFAULT '1',
  `money` int(11) NOT NULL DEFAULT '0',
  `kills` int(9) NOT NULL DEFAULT '0',
  `deaths` int(9) NOT NULL DEFAULT '0',
  `arens` varchar(256) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `did_jobs` int(11) NOT NULL DEFAULT '0',
  `zombie_kills` int(11) NOT NULL DEFAULT '0',
  `weapons_stats` varchar(256) NOT NULL DEFAULT '[ { "73": 0, "77": 0, "70": 0, "74": 0, "78": 0, "71": 0, "75": 0, "79": 0, "72": 0, "76": 0, "69": 0 } ]',
  `events_stats` varchar(256) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `solo_wins` int(11) NOT NULL DEFAULT '0',
  `shaders` varchar(100) NOT NULL DEFAULT '[ [ false, false, false, false, false, false, false ] ]',
  `personal_settings` varchar(50) NOT NULL DEFAULT '[ [ false, false ] ]',
  `playtime` int(11) NOT NULL DEFAULT '0',
  `skin` int(11) NOT NULL DEFAULT '0',
  `hitman` int(11) NOT NULL DEFAULT '0',
  `take_reward` int(9) NOT NULL DEFAULT '0',
  `bestDrift` int(11) NOT NULL DEFAULT '0',
  `job_points` varchar(256) NOT NULL DEFAULT '[ [ 0, 0 ] ]',
  `mute` int(11) NOT NULL DEFAULT '0',
  `jail` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_radio`
--

CREATE TABLE `ms_radio` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `name` text CHARACTER SET utf8 NOT NULL,
  `url` text CHARACTER SET utf8 NOT NULL,
  `vehicle` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_reports`
--

CREATE TABLE `ms_reports` (
  `id` int(11) NOT NULL,
  `player` text CHARACTER SET utf8 NOT NULL,
  `target` text CHARACTER SET utf8 NOT NULL,
  `reason` text CHARACTER SET utf8 NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `used` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT 'brak'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_slender`
--

CREATE TABLE `ms_slender` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `name` varchar(35) COLLATE utf8_unicode_ci NOT NULL,
  `time` int(9) NOT NULL,
  `pages` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_statues`
--

CREATE TABLE `ms_statues` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` int(9) NOT NULL,
  `dimension` int(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_teleports`
--

CREATE TABLE `ms_teleports` (
  `id` int(11) NOT NULL,
  `cmd` text NOT NULL,
  `type` int(1) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rot` float NOT NULL,
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_teleports`
--

INSERT INTO `ms_teleports` (`id`, `cmd`, `type`, `x`, `y`, `z`, `rot`, `interior`, `dimension`) VALUES
(3, 'ls', 1, 2510.6, -1674.77, 13.5391, 61.5711, 0, 0),
(4, 'ministunt', 4, 1115.39, 2651.81, 25.67, 320.732, 0, 0),
(5, 'zjezdzalnia', 2, -3866.55, 2362.87, 462.307, 179.846, 0, 0),
(6, 'amfiteatr', 2, 1046.72, -2470.11, 3.07082, 88.087, 0, 0),
(7, 'beachparty', 2, 289.928, -1897.45, 1.36094, 175.529, 0, 0),
(9, 'extreme', 4, -2118.89, -1574.42, 1985.58, 268.304, 0, 0),
(10, 'silownia', 2, 1223.84, -1456.28, 45.2547, 86.1753, 0, 100),
(11, 'kart', 3, -2091.99, -113.672, 35.3203, 180.533, 0, 0),
(12, 'megastunt', 4, -238.626, 3886.21, 14.2262, 89.0648, 0, 0),
(13, 'melina', 2, 2441.26, 1668.28, 557.802, 59.5001, 0, 0),
(14, 'minidisco', 2, 1886.12, -1421.43, -65.6484, 357.168, 0, 0),
(15, 'parkour', 3, 288.671, 2037.91, 79.4009, 94.3493, 0, 0),
(17, 'skocznia', 4, -1692.27, -2056.45, 211.17, 1.82101, 0, 0),
(18, 'spirala', 4, 892.718, 722.079, 153.806, 284.74, 0, 0),
(19, 'stuntls', 4, 1851.76, -2542.82, 13.5469, 268.436, 0, 0),
(20, 'torbmx', 3, 2927.94, -779.733, 10.9016, 269.375, 0, 0),
(21, 'waterland', 4, 2544.58, -2937.37, 200.989, 180.352, 0, 0),
(22, 'wspinaczka', 3, -1612.52, -7566.62, 2.01931, 358.355, 0, 0),
(23, 'drift', 3, -2494.62, -615.097, 132.562, 262.322, 0, 0),
(24, 'disco', 2, 1289.6, -1651.99, 13.5469, 90.9489, 0, 0),
(25, 'jumpcity', 3, -2227.72, -3125.15, 27.3463, 177.094, 0, 0),
(26, 'kart2', 3, 5234.04, -1925.56, 3.92, 64.4056, 0, 0),
(27, 'drag2', 3, 3046.24, 2126.87, 2.47656, 269.6, 0, 0),
(28, 'drag3', 3, 1575.21, -1242.37, 277.877, 357.959, 0, 0),
(29, 'drift2', 3, 3571.73, 864.991, 232.971, 353.372, 0, 0),
(30, 'ogrodnik', 5, 1264.8, -2041.21, 59.2703, 171.958, 0, 0),
(31, 'drift3', 3, -1647.83, -165.936, 14.1484, 314.596, 0, 0),
(32, 'ksw', 2, 2140.29, 972.565, 1040.79, 358.8, 0, 0),
(33, 'kapliczka', 2, 2500.29, 914.179, -1.42311, 269.545, 0, 0),
(34, 'kostnica', 2, 2774.67, -1423.35, 16.25, 268.941, 0, 0),
(35, 'rzeznia', 2, 2433.76, 5548.67, 10.6616, 266.771, 0, 0),
(36, 'zjazd', 4, 35.3161, -906.656, 1761.68, 180.291, 0, 0),
(38, 'waterjump', 4, 340.22, 2004.71, 571.7, 178.599, 0, 0),
(39, 'wyspa', 2, 615.183, -1924.51, 2.47137, 168.569, 0, 0),
(40, 'uniwersytet', 2, 1426.97, -1916.85, 1227.87, 88.9824, 0, 0),
(41, 'pieklo', 2, -655.367, 2372.77, 161.98, 265.415, 0, 0),
(42, 'lslot', 1, 1960.14, -2328.09, 13.5469, 179.984, 0, 0),
(43, 'lvlot', 1, 1648.14, 1596.09, 10.8203, 81.0172, 0, 0),
(44, 'lv', 1, 2166.37, 996.444, 10.813, 183.477, 0, 0),
(45, 'wojsko', 1, 346.443, 1795.17, 18.2083, 36.8075, 0, 0),
(49, 'zombie', 2, 598.76, -2632.42, 11.4869, 180.478, 0, 666),
(52, 'sf', 1, -2031.53, 135.024, 28.8359, 270.358, 0, 0),
(53, 'tune', 1, 898.91, -1220.72, 16.9766, 85.7523, 0, 0),
(54, 'salon', 1, 2126.78, -1124.41, 25.463, 165.108, 0, 0),
(59, 'kopalnia', 5, 2034.36, -492.795, 73.2179, 272.446, 0, 0),
(63, 'gielda', 1, 2422.1, -2039.94, 13.5469, 88.4166, 0, 0),
(64, 'tama', 1, -898.162, 2002.58, 60.9141, 218.821, 0, 0),
(66, 'stlot', 1, 419.239, 2524.94, 16.4945, 176.803, 0, 0),
(67, 'zjazd2', 4, 366.493, 2234.41, 195.654, 1.01901, 0, 0),
(68, 'zjazd3', 4, -482.055, 2499.79, 440.121, 270.26, 0, 0),
(69, 'zadupie', 1, -1405.73, -1478.44, 101.771, 266.497, 0, 0),
(70, 'kino', 2, 115.397, 1096.08, 13.6094, 172.661, 0, 0),
(71, 'gora', 1, -2260.59, -1700.89, 480.101, 62.0655, 0, 0),
(72, 'akina', 3, -2936.17, 462.182, 4.90657, 352.461, 0, 0),
(75, 'plaza', 1, 219.515, -1808.64, 4.49754, 184.422, 0, 0),
(76, 'taxi', 1, 1759.87, -1894.45, 13.5556, 264.486, 0, 0),
(77, 'spedycjals', 5, 2222.98, -2212.96, 13.5469, 311.437, 0, 0),
(78, 'spedycjalv', 5, 2859.11, 942.056, 10.75, 87.7354, 0, 0),
(79, 'spedycjasf', 5, -2134.26, -89.4512, 35.3203, 2.43076, 0, 0),
(80, 'pilot', 5, 1703.06, 1633.55, 10.5712, 90.9764, 0, 0),
(81, 'kasyno', 2, 2031.39, 1007.46, 10.8203, 89.6745, 0, 0),
(83, 'ghostisland', 6, 1834.52, -4245.53, 3.76733, 278.093, 0, 0),
(84, 'alhambra', 2, 1828.61, -1682.37, 13.5469, 267.178, 0, 0),
(85, 'farmworld', 2, 6218.88, -1592.16, 46.0683, 242.859, 0, 0),
(86, 'dzungla', 2, -180.18, 5372.28, 98.9783, 125.897, 0, 0),
(87, 'grecja', 2, 567.954, -3991.73, 5.05048, 274.709, 0, 0),
(88, 'wodospad', 2, -126, -4833, 3.5, 210.07, 0, 0),
(89, 'indianajones', 2, 4023.78, -5632.17, 28.2697, 200.045, 0, 0),
(90, 'egipt', 2, 6754.72, -1639.97, 18.2394, 63.9771, 0, 1),
(91, 'crossrace', 3, -2815.75, 1544, 2.10719, 350.417, 0, 1),
(92, 'cityrace', 3, 2887.21, -288.889, 1.67289, 101.721, 0, 1),
(94, 'slender', 2, -1648.88, -2256.5, 32.3295, 359.442, 0, 0),
(95, 'basen', 2, -1993.98, 1033.41, 55.7122, 4.85877, 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_truck`
--

CREATE TABLE `ms_truck` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `ms_truck`
--

INSERT INTO `ms_truck` (`id`, `x`, `y`, `z`) VALUES
(1, 2791.45, -2418.23, 14.219),
(2, -1876.75, -201.548, 17.3925),
(3, 2190.97, 913.806, 10.3623),
(4, 2112.25, 935.772, 10.3621),
(5, 1902.74, 992.593, 10.362),
(6, 2017.2, 1167.15, 10.3602),
(7, 1936, -1776.78, 13.0393),
(8, 2143.08, 1392.71, 10.3547),
(9, 2167.75, 1669.29, 10.3624),
(10, 482.683, -1518.86, 19.8542),
(11, 1347.19, 1277.21, 10.3623),
(12, 1003, -940.633, 41.8182),
(13, 1603.72, 1346.68, 10.3806),
(14, 1603.17, 1623.74, 10.3624),
(15, 1701.22, 1755.72, 10.3187),
(16, 1630.24, 1831.59, 10.3627),
(17, 1610.03, 2201, 10.3624),
(18, 1695.43, 2186.65, 10.3622),
(19, 1709.67, 2334.4, 10.362),
(20, 1874.4, 2267.01, 10.3236),
(21, -2465.14, 786.715, 34.777),
(22, 1985.87, 2439.95, 10.362),
(23, 1362.24, -1280.96, 13.1012),
(24, 2445.27, 2756.13, 10.2139),
(25, -2314.23, -147.272, 34.9265),
(26, 2907.11, 2408.58, 10.3473),
(27, -2109.45, 204.324, 34.8659),
(28, 1949.05, -2124.9, 13.2029),
(29, 2803.46, 1964.1, 10.2859),
(30, 2773.2, 1418.37, 9.28441),
(31, -1865.71, 854.255, 34.6198),
(32, 2808.36, 914.858, 10.2919),
(33, -1647.45, 1218.87, 6.71556),
(34, 2416.88, -1232.27, 24.0191),
(35, -1866.92, 1410.2, 6.79281),
(36, 659.237, -566.857, 15.9953),
(37, -2528.31, 1223.7, 37.0324),
(38, 1369.33, 700.692, 10.3624),
(39, 1482.8, 993.782, 10.3623),
(40, 249.982, -66.5732, 1.16037),
(41, 2266.26, -84.1289, 26.178),
(42, 989.729, 1711.74, 10.3687),
(43, 1028.02, 2128.26, 10.3624),
(44, -2726.47, -311.468, 6.64331),
(45, 1383.49, 454.71, 20.5042),
(46, 1522.81, 2773.49, 10.2139),
(47, -2522.16, 231.516, 10.7046),
(48, -1837.92, 136.051, 14.7221),
(49, 422.096, 2505.96, 16.0262),
(50, -1427.38, -294.56, 13.6039),
(51, -1965.04, -2439.75, 30.2825),
(52, -2522.12, -612.562, 132.166),
(53, 304.613, 1931.32, 17.1824),
(54, -44.2051, 2327.75, 23.4313),
(55, -1906.57, -782.265, 31.6277),
(56, -510.338, 2592.97, 52.9561),
(57, 1232.74, -1828.95, 13.0644),
(58, -1422.9, -1470.28, 101.245),
(59, -897.486, 2002.96, 60.4561),
(60, -1191.85, 1823.27, 41.2507),
(61, -1174.3, -1115.21, 127.87),
(62, -803.372, 1617.26, 26.6027),
(63, -828.585, 1435.77, 13.3088),
(64, -1104.99, -1620.95, 75.9705),
(65, -319.262, 1735.82, 42.2296),
(66, -75.5254, -1587.92, 2.27543),
(67, -2265.02, 533.774, 34.6226),
(68, -281.105, -2184.45, 28.3563),
(69, 15.6582, -2648.48, 40.0427),
(70, -294.998, 1520.56, 74.9011),
(71, -2464.81, 2239.39, 4.39464),
(72, 2390.96, -1977.63, 13.1204),
(73, -293.101, 1054.22, 19.1337),
(74, -1930.79, 2384.08, 49.0971),
(75, -1809.58, 2047.74, 8.67634),
(76, 605.539, 1201.27, 11.2585),
(77, -1291.67, 2713.24, 49.6666),
(78, 2032.14, -1416.77, 16.6511),
(79, -2794.61, 779.84, 49.6893),
(80, 667.084, -1277.15, 13.1192);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_vehicles`
--

CREATE TABLE `ms_vehicles` (
  `id` int(11) NOT NULL,
  `spawned` tinyint(1) NOT NULL DEFAULT '0',
  `ts_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ts_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `owner` int(11) NOT NULL DEFAULT '-1',
  `ownerFaction` int(11) NOT NULL DEFAULT '-1',
  `model` smallint(6) NOT NULL DEFAULT '400',
  `health` float NOT NULL DEFAULT '3000',
  `pos` varchar(128) DEFAULT '[[ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]]',
  `components` varchar(256) DEFAULT '[[ 0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]]',
  `paintjob` tinyint(4) NOT NULL DEFAULT '0',
  `panelstates` varchar(32) DEFAULT '[[ 0,0,0,0,0,0 ]]',
  `doorstate` varchar(32) DEFAULT '[[ 0,0,0,0,0 ]]',
  `wheelstate` varchar(32) DEFAULT '[[ -1,-1,-1,-1 ]]',
  `lightstate` varchar(32) DEFAULT '[[ 0,0,0 ]]',
  `headlights` varchar(32) DEFAULT '[[ 0,0,0 ]]',
  `colors` varchar(64) DEFAULT '[[ 0,0, 0,0, 0,0 ]]',
  `dimension` smallint(6) NOT NULL DEFAULT '0',
  `interior` smallint(6) NOT NULL DEFAULT '0',
  `license_plate` varchar(16) NOT NULL DEFAULT '000-000',
  `fuel` float NOT NULL DEFAULT '100',
  `dirt_lvl` tinyint(4) NOT NULL DEFAULT '0',
  `mileage` float NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `frozen` tinyint(1) NOT NULL DEFAULT '0',
  `max_fuel` int(11) NOT NULL,
  `max_acc` int(11) NOT NULL,
  `max_speed` int(11) NOT NULL,
  `blocked` varchar(50) NOT NULL DEFAULT '',
  `ownerName` varchar(22) NOT NULL DEFAULT 'Unknown',
  `gielda` int(11) NOT NULL DEFAULT '0',
  `gieldaCena` int(11) NOT NULL DEFAULT '0',
  `gieldaMiejsce` int(11) NOT NULL DEFAULT '0',
  `sharing_players` varchar(256) NOT NULL DEFAULT '[[  ]]'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_vehicleshop`
--

CREATE TABLE `ms_vehicleshop` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `type` text NOT NULL,
  `model` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `ms_vehicleshop`
--

INSERT INTO `ms_vehicleshop` (`id`, `name`, `type`, `model`, `price`) VALUES
(0, 'Sandking', 'sport', 495, 200000),
(1, 'Buffalo', 'sport', 402, 300000),
(2, 'Infernus', 'sport', 411, 750000),
(3, 'Cheetah', 'sport', 415, 450000),
(4, 'Banshee', 'sport', 429, 420000),
(5, 'Turismo', 'sport', 451, 600000),
(6, 'ZR-350', 'sport', 477, 365000),
(7, 'Comet', 'sport', 480, 400000),
(13, 'Super GT', 'sport', 506, 420000),
(14, 'Bullet', 'sport', 541, 500000),
(15, 'Windsor', 'sport', 555, 250000),
(16, 'Uranus', 'sport', 558, 200000),
(17, 'Jester', 'sport', 559, 375000),
(18, 'Sultan', 'sport', 560, 400000),
(19, 'Elegy', 'sport', 562, 400000),
(20, 'Flash', 'sport', 565, 250000),
(22, 'Euros', 'sport', 587, 250000),
(23, 'Alpha', 'sport', 602, 300000),
(24, 'Phoenix', 'sport', 603, 400000),
(25, 'Landstalker', 'casual', 400, 140000),
(26, 'Bravura', 'casual', 401, 130000),
(27, 'Perennial', 'casual', 404, 30000),
(28, 'Sentinel', 'casual', 405, 150000),
(29, 'Manana', 'casual', 410, 30000),
(30, 'Voodoo', 'casual', 412, 175000),
(31, 'Pony', 'casual', 413, 75000),
(34, 'Moonbeam', 'casual', 418, 30000),
(35, 'Esperanto', 'casual', 419, 140000),
(37, 'Washington', 'casual', 421, 110000),
(38, 'Bobcat', 'casual', 422, 50000),
(39, 'Premier', 'casual', 426, 160000),
(40, 'Previon', 'casual', 436, 35000),
(42, 'Stallion', 'casual', 439, 150000),
(44, 'Admiral', 'casual', 445, 90000),
(45, 'Solair', 'casual', 458, 50000),
(47, 'Glendale', 'casual', 466, 55000),
(48, 'Oceanic', 'casual', 467, 140000),
(50, 'Hermes', 'casual', 474, 170000),
(51, 'Sabre', 'casual', 475, 150000),
(52, 'Walton', 'casual', 478, 30000),
(53, 'Regina', 'casual', 479, 80000),
(54, 'Burrito', 'casual', 482, 140000),
(55, 'Rancher', 'casual', 489, 165000),
(57, 'Virgo', 'casual', 491, 60000),
(58, 'Greenwood', 'casual', 492, 90000),
(60, 'Blista Compact', 'casual', 496, 125000),
(61, 'Mesa', 'casual', 500, 145000),
(63, 'Elegant', 'casual', 507, 130000),
(64, 'Nebula', 'casual', 516, 75000),
(65, 'Majestic', 'casual', 517, 75000),
(66, 'Buccaneer', 'casual', 518, 150000),
(67, 'Fortune', 'casual', 526, 100000),
(68, 'Cadrona', 'casual', 527, 75000),
(70, 'Willard', 'casual', 529, 40000),
(71, 'Feltzer', 'casual', 533, 165000),
(72, 'Remington', 'casual', 534, 150000),
(73, 'Slamvan', 'casual', 535, 140000),
(74, 'Blade', 'casual', 536, 175000),
(75, 'Vincent', 'casual', 540, 40000),
(76, 'Clover', 'casual', 542, 80000),
(77, 'Sadler', 'casual', 543, 30000),
(78, 'Intruder', 'casual', 546, 45000),
(79, 'Primo', 'casual', 547, 80000),
(80, 'Tampa', 'casual', 549, 50000),
(81, 'Sunrise', 'casual', 550, 130000),
(82, 'Merit', 'casual', 551, 80000),
(84, 'Yosemite', 'casual', 554, 90000),
(85, 'Stratum', 'casual', 561, 130000),
(86, 'Tahoma', 'casual', 566, 95000),
(87, 'Savanna', 'casual', 567, 150000),
(88, 'Broadway', 'casual', 575, 160000),
(89, 'Tornado', 'casual', 576, 175000),
(90, 'Huntley', 'casual', 579, 155000),
(91, 'Stafford', 'casual', 580, 100000),
(92, 'Emperor', 'casual', 585, 60000),
(93, 'Club', 'casual', 589, 150000),
(98, 'Picador', 'casual', 600, 45000),
(105, 'BF Injection', 'casual', 424, 130000),
(128, 'BF-400', 'motor', 581, 200000),
(129, 'Faggio', 'motor', 462, 30000),
(130, 'FCR-900', 'motor', 521, 160000),
(131, 'Freeway', 'motor', 463, 110000),
(132, 'NRG-500', 'motor', 522, 250000),
(133, 'PCJ-600', 'motor', 461, 175000),
(135, 'Sanchez', 'motor', 468, 80000),
(136, 'Wayfarer', 'motor', 586, 100000),
(146, 'Bike', 'bike', 509, 15000),
(147, 'BMX', 'bike', 481, 17500),
(148, 'Mountain Bike', 'bike', 510, 20000),
(149, 'Quad', 'motor', 471, 150000),
(150, 'Patriot', 'casual', 470, 400000),
(151, 'Bandito', 'sport', 568, 175000),
(152, 'Stretch', 'casual', 409, 200000);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_vehicles_old`
--

CREATE TABLE `ms_vehicles_old` (
  `id` int(11) NOT NULL,
  `model` int(4) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `color` varchar(100) NOT NULL,
  `locked` int(1) NOT NULL,
  `doors` varchar(40) NOT NULL,
  `hp` float NOT NULL,
  `upgrades` varchar(500) NOT NULL,
  `wheels` varchar(20) NOT NULL,
  `owner` int(11) NOT NULL,
  `spawned` int(1) NOT NULL,
  `mileage` int(10) NOT NULL,
  `paintjob` int(11) NOT NULL DEFAULT '3',
  `lights` varchar(100) NOT NULL DEFAULT '[ [ 255, 255, 255 ] ]'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ms_whitelist`
--

CREATE TABLE `ms_whitelist` (
  `id` int(11) NOT NULL,
  `serial` varchar(32) CHARACTER SET ascii DEFAULT NULL COMMENT 'serial',
  `notes` varchar(128) DEFAULT NULL COMMENT 'informacje dodatkowe'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `ms_accounts`
--
ALTER TABLE `ms_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_achievements`
--
ALTER TABLE `ms_achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_adminlogs`
--
ALTER TABLE `ms_adminlogs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_anim`
--
ALTER TABLE `ms_anim`
  ADD PRIMARY KEY (`anim_uid`);

--
-- Indexes for table `ms_bans`
--
ALTER TABLE `ms_bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_challenges`
--
ALTER TABLE `ms_challenges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_custominteriors`
--
ALTER TABLE `ms_custominteriors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_entrances`
--
ALTER TABLE `ms_entrances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_furniture`
--
ALTER TABLE `ms_furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_furnitureshop`
--
ALTER TABLE `ms_furnitureshop`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_gangs`
--
ALTER TABLE `ms_gangs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_gangs_areas`
--
ALTER TABLE `ms_gangs_areas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_gangs_bases`
--
ALTER TABLE `ms_gangs_bases`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_gangs_tags`
--
ALTER TABLE `ms_gangs_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_houses`
--
ALTER TABLE `ms_houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_logging`
--
ALTER TABLE `ms_logging`
  ADD PRIMARY KEY (`idx`),
  ADD KEY `typy` (`uid`,`type`);

--
-- Indexes for table `ms_players`
--
ALTER TABLE `ms_players`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_radio`
--
ALTER TABLE `ms_radio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_reports`
--
ALTER TABLE `ms_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_slender`
--
ALTER TABLE `ms_slender`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_statues`
--
ALTER TABLE `ms_statues`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_teleports`
--
ALTER TABLE `ms_teleports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_truck`
--
ALTER TABLE `ms_truck`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_vehicles`
--
ALTER TABLE `ms_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_vehicleshop`
--
ALTER TABLE `ms_vehicleshop`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_vehicles_old`
--
ALTER TABLE `ms_vehicles_old`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_whitelist`
--
ALTER TABLE `ms_whitelist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `ms_accounts`
--
ALTER TABLE `ms_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2815;
--
-- AUTO_INCREMENT dla tabeli `ms_achievements`
--
ALTER TABLE `ms_achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1919;
--
-- AUTO_INCREMENT dla tabeli `ms_adminlogs`
--
ALTER TABLE `ms_adminlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `ms_anim`
--
ALTER TABLE `ms_anim`
  MODIFY `anim_uid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=391;
--
-- AUTO_INCREMENT dla tabeli `ms_bans`
--
ALTER TABLE `ms_bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;
--
-- AUTO_INCREMENT dla tabeli `ms_challenges`
--
ALTER TABLE `ms_challenges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=278;
--
-- AUTO_INCREMENT dla tabeli `ms_custominteriors`
--
ALTER TABLE `ms_custominteriors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT dla tabeli `ms_entrances`
--
ALTER TABLE `ms_entrances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
--
-- AUTO_INCREMENT dla tabeli `ms_furniture`
--
ALTER TABLE `ms_furniture`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5662;
--
-- AUTO_INCREMENT dla tabeli `ms_furnitureshop`
--
ALTER TABLE `ms_furnitureshop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=387;
--
-- AUTO_INCREMENT dla tabeli `ms_gangs`
--
ALTER TABLE `ms_gangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT dla tabeli `ms_gangs_areas`
--
ALTER TABLE `ms_gangs_areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;
--
-- AUTO_INCREMENT dla tabeli `ms_gangs_bases`
--
ALTER TABLE `ms_gangs_bases`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT dla tabeli `ms_gangs_tags`
--
ALTER TABLE `ms_gangs_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;
--
-- AUTO_INCREMENT dla tabeli `ms_houses`
--
ALTER TABLE `ms_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=404;
--
-- AUTO_INCREMENT dla tabeli `ms_logging`
--
ALTER TABLE `ms_logging`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1593;
--
-- AUTO_INCREMENT dla tabeli `ms_players`
--
ALTER TABLE `ms_players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2815;
--
-- AUTO_INCREMENT dla tabeli `ms_radio`
--
ALTER TABLE `ms_radio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7284;
--
-- AUTO_INCREMENT dla tabeli `ms_reports`
--
ALTER TABLE `ms_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=569;
--
-- AUTO_INCREMENT dla tabeli `ms_slender`
--
ALTER TABLE `ms_slender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;
--
-- AUTO_INCREMENT dla tabeli `ms_statues`
--
ALTER TABLE `ms_statues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;
--
-- AUTO_INCREMENT dla tabeli `ms_teleports`
--
ALTER TABLE `ms_teleports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;
--
-- AUTO_INCREMENT dla tabeli `ms_truck`
--
ALTER TABLE `ms_truck`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;
--
-- AUTO_INCREMENT dla tabeli `ms_vehicles`
--
ALTER TABLE `ms_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1297;
--
-- AUTO_INCREMENT dla tabeli `ms_vehicles_old`
--
ALTER TABLE `ms_vehicles_old`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT dla tabeli `ms_whitelist`
--
ALTER TABLE `ms_whitelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
