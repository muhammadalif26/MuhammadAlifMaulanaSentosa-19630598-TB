-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 09, 2022 at 01:23 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_gudang`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `query_fakturtransaksi`
-- (See below for the actual view)
--
CREATE TABLE `query_fakturtransaksi` (
`id_transaksi` varchar(10)
,`id_barang` varchar(10)
,`nama_barang` varchar(100)
,`harga_satuan` int(11)
,`jumlah` int(11)
,`subtotal` int(255)
,`id_transaksilaporan` varchar(10)
,`total` int(11)
,`bayar` int(11)
,`kembali` int(11)
,`tanggal` int(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `query_laporanpasok`
-- (See below for the actual view)
--
CREATE TABLE `query_laporanpasok` (
`id_pasok` varchar(10)
,`id_barang` varchar(10)
,`nama_barang` varchar(100)
,`jumlah` int(11)
,`tanggal_masuk` varchar(20)
,`stok_total` bigint(21) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `query_stoktotal`
-- (See below for the actual view)
--
CREATE TABLE `query_stoktotal` (
`id_barang` varchar(10)
,`stok_total` bigint(21) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `query_total`
-- (See below for the actual view)
--
CREATE TABLE `query_total` (
`total_harga` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `tb_barang`
--

CREATE TABLE `tb_barang` (
  `id_barang` varchar(10) CHARACTER SET latin1 NOT NULL,
  `nama_barang` varchar(100) CHARACTER SET latin1 NOT NULL,
  `jenis_barang` varchar(50) CHARACTER SET latin1 NOT NULL,
  `harga_beli` int(11) NOT NULL,
  `harga_jual` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_laporan`
--

CREATE TABLE `tb_laporan` (
  `id_transaksilaporan` varchar(10) CHARACTER SET latin1 NOT NULL,
  `total` int(11) NOT NULL,
  `bayar` int(11) NOT NULL,
  `kembali` int(11) NOT NULL,
  `tanggal` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pasok`
--

CREATE TABLE `tb_pasok` (
  `id_pasok` varchar(10) CHARACTER SET latin1 NOT NULL,
  `id_barang` varchar(10) CHARACTER SET latin1 NOT NULL,
  `nama_barang` varchar(100) CHARACTER SET latin1 NOT NULL,
  `jumlah` int(11) NOT NULL,
  `tanggal_masuk` varchar(20) CHARACTER SET latin1 NOT NULL,
  `pemasok` varchar(100) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pemasok`
--

CREATE TABLE `tb_pemasok` (
  `id_pemasok` varchar(10) CHARACTER SET latin1 NOT NULL,
  `nama_pemasok` varchar(100) CHARACTER SET latin1 NOT NULL,
  `alamat` varchar(500) CHARACTER SET latin1 NOT NULL,
  `no_hp` int(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pengguna`
--

CREATE TABLE `tb_pengguna` (
  `id_barang` varchar(10) CHARACTER SET latin1 NOT NULL,
  `nama_barang` varchar(100) CHARACTER SET latin1 NOT NULL,
  `jenis_barang` varchar(50) CHARACTER SET latin1 NOT NULL,
  `harga_beli` int(11) NOT NULL,
  `harga_jual` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_transaksi`
--

CREATE TABLE `tb_transaksi` (
  `id_transaksi` varchar(10) CHARACTER SET latin1 NOT NULL,
  `id_barang` varchar(10) CHARACTER SET latin1 NOT NULL,
  `nama_barang` varchar(100) CHARACTER SET latin1 NOT NULL,
  `harga_satuan` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `subtotal` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `tb_transaksi`
--
DELIMITER $$
CREATE TRIGGER `ajukan_barang` AFTER INSERT ON `tb_transaksi` FOR EACH ROW BEGIN

UPDATE tb_barang
SET jumlah = jumlah - NEW.jumlah

WHERE id_barang= NEW.id_barang;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `undurkan_barang` AFTER DELETE ON `tb_transaksi` FOR EACH ROW BEGIN

UPDATE tb_barang

SET jumlah = jumlah + OLD.jumlah

WHERE id_barang= OLD.id.barang;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `query_fakturtransaksi`
--
DROP TABLE IF EXISTS `query_fakturtransaksi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `query_fakturtransaksi`  AS SELECT `tb_transaksi`.`id_transaksi` AS `id_transaksi`, `tb_transaksi`.`id_barang` AS `id_barang`, `tb_transaksi`.`nama_barang` AS `nama_barang`, `tb_transaksi`.`harga_satuan` AS `harga_satuan`, `tb_transaksi`.`jumlah` AS `jumlah`, `tb_transaksi`.`subtotal` AS `subtotal`, `tb_laporan`.`id_transaksilaporan` AS `id_transaksilaporan`, `tb_laporan`.`total` AS `total`, `tb_laporan`.`bayar` AS `bayar`, `tb_laporan`.`kembali` AS `kembali`, `tb_laporan`.`tanggal` AS `tanggal` FROM (`tb_transaksi` join `tb_laporan`) WHERE `tb_transaksi`.`id_transaksi` = `tb_laporan`.`id_transaksilaporan` ;

-- --------------------------------------------------------

--
-- Structure for view `query_laporanpasok`
--
DROP TABLE IF EXISTS `query_laporanpasok`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `query_laporanpasok`  AS SELECT `tb_pasok`.`id_pasok` AS `id_pasok`, `tb_pasok`.`id_barang` AS `id_barang`, `tb_pasok`.`nama_barang` AS `nama_barang`, `tb_pasok`.`jumlah` AS `jumlah`, `tb_pasok`.`tanggal_masuk` AS `tanggal_masuk`, `query_stoktotal`.`stok_total` AS `stok_total` FROM (`tb_pasok` join `query_stoktotal`) WHERE `tb_pasok`.`id_barang` = `query_stoktotal`.`id_barang` ;

-- --------------------------------------------------------

--
-- Structure for view `query_stoktotal`
--
DROP TABLE IF EXISTS `query_stoktotal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `query_stoktotal`  AS SELECT `tb_pasok`.`id_barang` AS `id_barang`, cast(`tb_barang`.`jumlah` as unsigned) + `tb_pasok`.`jumlah` AS `stok_total` FROM (`tb_pasok` join `tb_barang`) WHERE `tb_pasok`.`id_barang` = `tb_barang`.`id_barang` ;

-- --------------------------------------------------------

--
-- Structure for view `query_total`
--
DROP TABLE IF EXISTS `query_total`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `query_total`  AS SELECT sum(`tb_transaksi`.`jumlah`) AS `total_harga` FROM `tb_transaksi` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_barang`
--
ALTER TABLE `tb_barang`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `tb_pasok`
--
ALTER TABLE `tb_pasok`
  ADD PRIMARY KEY (`id_pasok`);

--
-- Indexes for table `tb_pengguna`
--
ALTER TABLE `tb_pengguna`
  ADD PRIMARY KEY (`id_barang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
