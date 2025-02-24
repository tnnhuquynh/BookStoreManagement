USE [master]
GO
/****** Object:  Database [Bookstore]    Script Date: 12/14/2019 9:57:28 AM ******/
CREATE DATABASE [Bookstore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Bookstore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Bookstore.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Bookstore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Bookstore_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Bookstore] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Bookstore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Bookstore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Bookstore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Bookstore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Bookstore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Bookstore] SET ARITHABORT OFF 
GO
ALTER DATABASE [Bookstore] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Bookstore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Bookstore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Bookstore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Bookstore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Bookstore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Bookstore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Bookstore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Bookstore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Bookstore] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Bookstore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Bookstore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Bookstore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Bookstore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Bookstore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Bookstore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Bookstore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Bookstore] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Bookstore] SET  MULTI_USER 
GO
ALTER DATABASE [Bookstore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Bookstore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Bookstore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Bookstore] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Bookstore] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Bookstore]
GO
/****** Object:  Schema [Book]    Script Date: 12/14/2019 9:57:28 AM ******/
CREATE SCHEMA [Book]
GO
/****** Object:  Schema [Employee]    Script Date: 12/14/2019 9:57:28 AM ******/
CREATE SCHEMA [Employee]
GO
/****** Object:  Schema [Sales]    Script Date: 12/14/2019 9:57:28 AM ******/
CREATE SCHEMA [Sales]
GO
/****** Object:  UserDefinedFunction [dbo].[fnBestSellers]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fnBestSellers] () returns @OutTable table (BookID int not null, Name nvarchar(100) not null, Purchase int null, Path nvarchar(100) null) 
begin 
	insert @OutTable 
		   select ChiTietSach.MaSach, Ten, LuotMua, Path
		   from Sales.BanSach join Book.ChiTietSach on ChiTietSach.MaSach = BanSach.MaSach
		   where LuotMua > 50;
	return;
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnKiemTraSL]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnKiemTraSL] (@mas int, @sl int) returns int
begin
	declare @tk int;
	set @tk = dbo.fnLaySLTonKho(@mas);
	if (@tk < @sl) return @tk;
	return @sl;
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnLayLuotMua]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnLayLuotMua] (@mas int) returns int
begin 
	return (select LuotMua from Sales.BanSach where MaSach = @mas)
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnLayMaNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnLayMaNH]() returns nvarchar(50)
begin
	declare @manh nvarchar(50);
	select top 1 @manh = MaDon
	from Sales.NhapHang
	order by MaDon desc;
	return @manh;
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnLaySLTonKho]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnLaySLTonKho] (@mas int) returns int
begin 
	return (select TonKho from Sales.BanSach where MaSach = @mas)
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnLayTienNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnLayTienNH](@m int, @y int) returns decimal
begin
	return (select sum(Tong)
	from Sales.NhapHang
	where NgayNhan is not null and MONTH(NgayNhan) = @m and YEAR(NgayNhan) = @y)
end;
GO
/****** Object:  UserDefinedFunction [dbo].[fnSoKH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnSoKH]() returns int
begin 
return(select count(*) from Sales.KhachHang)
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnSoNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnSoNV]() returns int
begin 
return(select count(*) from Employee.NhanSu)
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fnSoSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnSoSach]() returns int
begin 
return(select count(*) from Book.ChiTietSach)
end;

GO
/****** Object:  UserDefinedFunction [dbo].[spLayDiemKH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[spLayDiemKH] (@id nvarchar(20)) returns int
begin
	return(select DiemTich
		from Sales.KhachHang where MaKH = @id)
end;

GO
/****** Object:  Table [Book].[ChiTietSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[ChiTietSach](
	[MaSach] [int] IDENTITY(1,1) NOT NULL,
	[Ten] [nvarchar](100) NOT NULL,
	[TacGia] [nvarchar](50) NOT NULL,
	[NgonNgu] [nvarchar](50) NOT NULL,
	[NCC] [nvarchar](50) NOT NULL,
	[KhuVuc] [nvarchar](50) NOT NULL,
	[TheLoai] [nvarchar](50) NOT NULL,
	[KeSach] [int] NOT NULL,
	[GiaGoc] [money] NOT NULL,
	[Path] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Book].[GiamGia]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[GiamGia](
	[MaGiamGia] [nvarchar](50) NOT NULL,
	[NgayBatDau] [date] NOT NULL,
	[NgayKetThuc] [date] NOT NULL,
	[ChiTiet] [nvarchar](100) NOT NULL,
	[PhanTramGiam] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGiamGia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Book].[NhaCungCap]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[NhaCungCap](
	[MaNCC] [nvarchar](50) NOT NULL,
	[TenNCC] [nvarchar](50) NOT NULL,
	[SDT] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Employee].[DangNhap]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Employee].[DangNhap](
	[Username] [nchar](9) NOT NULL,
	[Pass] [nvarchar](50) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Employee].[NhanSu]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Employee].[NhanSu](
	[MaNV] [nchar](9) NOT NULL,
	[HoTen] [nvarchar](50) NOT NULL,
	[SDT] [nvarchar](20) NOT NULL,
	[CongViec] [nvarchar](50) NOT NULL,
	[DiaChi] [nvarchar](100) NOT NULL,
	[Path] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[BanSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[BanSach](
	[MaSach] [int] NOT NULL,
	[GiaBan] [money] NOT NULL,
	[TonKho] [int] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[LuotMua] [int] NULL,
UNIQUE NONCLUSTERED 
(
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[ChiTietHD]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[ChiTietHD](
	[MaHD] [nvarchar](50) NOT NULL,
	[MaSach] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[ThanhTien] [money] NOT NULL,
 CONSTRAINT [PK_ChiTietHD_1] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[ChiTietNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[ChiTietNH](
	[MaDon] [nvarchar](50) NOT NULL,
	[MaSach] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[ThanhTien] [money] NOT NULL,
 CONSTRAINT [PK_ChiTietNH_1] PRIMARY KEY CLUSTERED 
(
	[MaDon] ASC,
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[HoaDon]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[HoaDon](
	[MaHD] [nvarchar](50) NOT NULL,
	[NgayLap] [date] NOT NULL,
	[Tong] [money] NOT NULL,
	[MaKH] [nvarchar](20) NULL,
	[MaNV] [nchar](9) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[KhachHang]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[KhachHang](
	[MaKH] [nvarchar](20) NOT NULL,
	[TenKH] [nvarchar](50) NOT NULL,
	[DiemTich] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[NhapHang]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[NhapHang](
	[MaDon] [nvarchar](50) NOT NULL,
	[NgayLap] [date] NOT NULL,
	[NguoiLap] [nchar](9) NOT NULL,
	[NCC] [nvarchar](50) NOT NULL,
	[Tong] [money] NOT NULL,
	[NgayNhan] [date] NULL,
	[NguoiNhan] [nchar](9) NULL,
	[ViTri] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[ThuNhapThang]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[ThuNhapThang](
	[Thang] [nvarchar](50) NOT NULL,
	[TienBanSach] [money] NULL,
	[TienNhapHang] [money] NULL,
	[ThuNhap] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[Thang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vLiteraryLines]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vLiteraryLines]
as
	select distinct KhuVuc, count(MaSach) as SoSach
	from Book.ChiTietSach
	group by KhuVuc;

GO
/****** Object:  View [dbo].[vNhaCungCap]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vNhaCungCap]
as
	select TenNcc, MaNcc from Book.NhaCungCap;

GO
/****** Object:  View [dbo].[vSoNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vSoNV]
as
	select distinct CongViec, count(*) as SoNV
	from Employee.NhanSu
	where not CongViec = N'Quản lí'
	group by CongViec;

GO
/****** Object:  View [dbo].[vUnderStock]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vUnderStock]
as
	select ChiTietSach.MaSach, Ten, TonKho, Path
	from Sales.BanSach join Book.ChiTietSach on ChiTietSach.MaSach = BanSach.MaSach
	where TonKho < 5;

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [TenSach]    Script Date: 12/14/2019 9:57:28 AM ******/
CREATE NONCLUSTERED INDEX [TenSach] ON [Book].[ChiTietSach]
(
	[Ten] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Book].[ChiTietSach]  WITH CHECK ADD  CONSTRAINT [fk_NCC_ChiTietSach] FOREIGN KEY([NCC])
REFERENCES [Book].[NhaCungCap] ([MaNCC])
GO
ALTER TABLE [Book].[ChiTietSach] CHECK CONSTRAINT [fk_NCC_ChiTietSach]
GO
ALTER TABLE [Employee].[DangNhap]  WITH CHECK ADD  CONSTRAINT [fk_NhanSu_DangNhap] FOREIGN KEY([Username])
REFERENCES [Employee].[NhanSu] ([MaNV])
GO
ALTER TABLE [Employee].[DangNhap] CHECK CONSTRAINT [fk_NhanSu_DangNhap]
GO
ALTER TABLE [Sales].[BanSach]  WITH CHECK ADD  CONSTRAINT [fk_ChiTietSach_BanSach] FOREIGN KEY([MaSach])
REFERENCES [Book].[ChiTietSach] ([MaSach])
GO
ALTER TABLE [Sales].[BanSach] CHECK CONSTRAINT [fk_ChiTietSach_BanSach]
GO
ALTER TABLE [Sales].[BanSach]  WITH NOCHECK ADD  CONSTRAINT [fk_MaGiamGia_BanSach] FOREIGN KEY([Code])
REFERENCES [Book].[GiamGia] ([MaGiamGia])
GO
ALTER TABLE [Sales].[BanSach] CHECK CONSTRAINT [fk_MaGiamGia_BanSach]
GO
ALTER TABLE [Sales].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [fk_ChiTietSach_ChiTietHD] FOREIGN KEY([MaSach])
REFERENCES [Book].[ChiTietSach] ([MaSach])
GO
ALTER TABLE [Sales].[ChiTietHD] CHECK CONSTRAINT [fk_ChiTietSach_ChiTietHD]
GO
ALTER TABLE [Sales].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [fk_HoaDon_ChiTietHD] FOREIGN KEY([MaHD])
REFERENCES [Sales].[HoaDon] ([MaHD])
GO
ALTER TABLE [Sales].[ChiTietHD] CHECK CONSTRAINT [fk_HoaDon_ChiTietHD]
GO
ALTER TABLE [Sales].[ChiTietNH]  WITH CHECK ADD  CONSTRAINT [fk_ChiTietSach_ChiTietNH] FOREIGN KEY([MaSach])
REFERENCES [Book].[ChiTietSach] ([MaSach])
GO
ALTER TABLE [Sales].[ChiTietNH] CHECK CONSTRAINT [fk_ChiTietSach_ChiTietNH]
GO
ALTER TABLE [Sales].[ChiTietNH]  WITH CHECK ADD  CONSTRAINT [fk_NhapHang_ChiTietNH] FOREIGN KEY([MaDon])
REFERENCES [Sales].[NhapHang] ([MaDon])
GO
ALTER TABLE [Sales].[ChiTietNH] CHECK CONSTRAINT [fk_NhapHang_ChiTietNH]
GO
ALTER TABLE [Sales].[HoaDon]  WITH CHECK ADD  CONSTRAINT [fk_KhachHang_HoaDon] FOREIGN KEY([MaKH])
REFERENCES [Sales].[KhachHang] ([MaKH])
GO
ALTER TABLE [Sales].[HoaDon] CHECK CONSTRAINT [fk_KhachHang_HoaDon]
GO
ALTER TABLE [Sales].[HoaDon]  WITH CHECK ADD  CONSTRAINT [fk_NhanSu_HoaDon] FOREIGN KEY([MaNV])
REFERENCES [Employee].[NhanSu] ([MaNV])
GO
ALTER TABLE [Sales].[HoaDon] CHECK CONSTRAINT [fk_NhanSu_HoaDon]
GO
ALTER TABLE [Sales].[NhapHang]  WITH CHECK ADD  CONSTRAINT [fk_NCC_NhapHang] FOREIGN KEY([NCC])
REFERENCES [Book].[NhaCungCap] ([MaNCC])
GO
ALTER TABLE [Sales].[NhapHang] CHECK CONSTRAINT [fk_NCC_NhapHang]
GO
ALTER TABLE [Sales].[NhapHang]  WITH CHECK ADD  CONSTRAINT [fk_NhanSu_NH] FOREIGN KEY([NguoiNhan])
REFERENCES [Employee].[NhanSu] ([MaNV])
GO
ALTER TABLE [Sales].[NhapHang] CHECK CONSTRAINT [fk_NhanSu_NH]
GO
ALTER TABLE [Sales].[NhapHang]  WITH CHECK ADD  CONSTRAINT [fk_NhanSu_NhapHang] FOREIGN KEY([NguoiLap])
REFERENCES [Employee].[NhanSu] ([MaNV])
GO
ALTER TABLE [Sales].[NhapHang] CHECK CONSTRAINT [fk_NhanSu_NhapHang]
GO
/****** Object:  StoredProcedure [dbo].[spDangNhap]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDangNhap]
	@TenDN nchar(9),
	@Pass nvarchar(50)
as
	select CongViec
	from Employee.NhanSu join Employee.DangNhap on Employee.NhanSu.MaNV = Employee.DangNhap.Username
	where Username = @TenDN and Pass = @Pass;

GO
/****** Object:  StoredProcedure [dbo].[spDieuChinhSLSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDieuChinhSLSach]
	@mas int, @sl int
as
	begin tran
	save tran ThemLuotMua
		declare @lm1 int = 0, @lm2 int = 0;
		set @lm2 = dbo.fnLayLuotMua(@mas);
		set @lm1 = @sl + dbo.fnLayLuotMua(@mas);
		if (@lm2 = dbo.fnLayLuotMua(@mas)) 
			update Sales.BanSach set LuotMua = @lm1 where MaSach = @mas;
		else rollback tran ThemLuotMua;			
	save tran TruSL
		declare @tk int = 0;
		set @lm2 = dbo.fnLaySLTonKho(@mas);
		set @lm1 = dbo.fnLaySLTonKho(@mas) - @sl;
		if (@lm2 = dbo.fnLaySLTonKho(@mas)) 
			update Sales.BanSach set TonKho = @lm1 where MaSach = @mas;
		else rollback tran TruSL;		
	commit tran;

GO
/****** Object:  StoredProcedure [dbo].[spGoMaGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spGoMaGG]
	@magg nvarchar(50)
as
	update Sales.BanSach set Code = null where Code = @magg;

GO
/****** Object:  StoredProcedure [dbo].[spLayChiSachTheoMa]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiSachTheoMa]
	@mas int
as
	select ChiTietSach.MaSach, Ten, TacGia, NCC, NgonNgu, KhuVuc, TheLoai, KeSach, GiaGoc, GiaBan, Path, BanSach.Code, TonKho, BanSach.LuotMua 
	from Sales.BanSach join Book.ChiTietSach on Sales.BanSach.MaSach = Book.ChiTietSach.MaSach
	where ChiTietSach.MaSach = @mas;

GO
/****** Object:  StoredProcedure [dbo].[spLayChiTietHD]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiTietHD]
	@mahd nvarchar(50)
as
	select *
	from Sales.ChiTietHD
	where MaHD = @mahd;

GO
/****** Object:  StoredProcedure [dbo].[spLayChiTietMaGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiTietMaGG]
	@magg nvarchar(50)
as
	select * from Book.GiamGia where MaGiamGia = @magg;

GO
/****** Object:  StoredProcedure [dbo].[spLayChiTietNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiTietNH]
	@madon nvarchar(50)
as
	select * from Sales.ChiTietNH where MaDon = @madon;

GO
/****** Object:  StoredProcedure [dbo].[spLayChiTietSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiTietSach]
as
	select ChiTietSach.MaSach, Ten, TacGia, NCC, NgonNgu, KhuVuc, TheLoai, KeSach, GiaGoc, GiaBan, Path, BanSach.Code, TonKho, BanSach.LuotMua 
	from Sales.BanSach join Book.ChiTietSach on Sales.BanSach.MaSach = Book.ChiTietSach.MaSach

GO
/****** Object:  StoredProcedure [dbo].[spLayChiTietSachTheoMa]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayChiTietSachTheoMa] 
	@mas int
as 
	select ChiTietSach.MaSach, Ten, TacGia, NCC, NgonNgu, KhuVuc, TheLoai, KeSach, GiaGoc, GiaBan, BanSach.Code, TonKho, BanSach.LuotMua, ChiTietSach.Path
	from Sales.BanSach join Book.ChiTietSach on Sales.BanSach.MaSach = Book.ChiTietSach.MaSach
	where ChiTietSach.MaSach = @mas;

GO
/****** Object:  StoredProcedure [dbo].[spLayChucVu]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spLayChucVu]
as
	select distinct CongViec
	from Employee.NhanSu;

GO
/****** Object:  StoredProcedure [dbo].[spLayDoanhThu]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayDoanhThu]
	@nam nvarchar(10)
as
	select Thang, ThuNhap
	from Sales.ThuNhapThang
	where RIGHT(Thang, 4) = @nam;

GO
/****** Object:  StoredProcedure [dbo].[spLayDoanhThu2]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayDoanhThu2]
as
	select * from Sales.ThuNhapThang;

GO
/****** Object:  StoredProcedure [dbo].[spLayDongSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayDongSach]
as
	select distinct KhuVuc
	from Book.ChiTietSach;	

GO
/****** Object:  StoredProcedure [dbo].[spLayGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayGG]
as
	select * from Book.GiamGia;

GO
/****** Object:  StoredProcedure [dbo].[spLayHDTheoThang]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayHDTheoThang]
	@thang nvarchar(50),
	@nam nvarchar(50)
as
	select *
	from Sales.HoaDon
	where convert(nvarchar(50), MONTH(HoaDon.NgayLap)) = @thang and convert(nvarchar(50), Year(HoaDon.NgayLap)) = @nam;

GO
/****** Object:  StoredProcedure [dbo].[spLayHoaDon]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayHoaDon]
as
	select *
	from Sales.HoaDon;

GO
/****** Object:  StoredProcedure [dbo].[spLayInfo]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spLayInfo]
	@MaNV nchar(9)
as 
	select *
	from Employee.NhanSu
	where MaNV = @MaNV;

GO
/****** Object:  StoredProcedure [dbo].[spLayKH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayKH]
as
	select * from Sales.KhachHang;

GO
/****** Object:  StoredProcedure [dbo].[spLayKhachHang]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayKhachHang]
as
	select MaKH
	from Sales.KhachHang;

GO
/****** Object:  StoredProcedure [dbo].[spLayKHTheoMa]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayKHTheoMa]
	@id nvarchar(20)
as
	select * from Sales.KhachHang where MaKH = @id;

GO
/****** Object:  StoredProcedure [dbo].[spLayMaGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayMaGG]
as
	select MaGiamGia
	from Book.GiamGia;

GO
/****** Object:  StoredProcedure [dbo].[spLayNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayNCC]
as
	select *
	from Book.NhaCungCap;

GO
/****** Object:  StoredProcedure [dbo].[spLayNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayNH] 
as
	select * from Sales.NhapHang;

GO
/****** Object:  StoredProcedure [dbo].[spLayNHTheoNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayNHTheoNCC]
	@mancc nvarchar(50)
as 
	select * from Sales.NhapHang where NCC = @mancc;

GO
/****** Object:  StoredProcedure [dbo].[spLayNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayNV]
as
	select * from Employee.NhanSu;

GO
/****** Object:  StoredProcedure [dbo].[spLaySachTheoNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLaySachTheoNCC]
	@ncc nvarchar(50)
as
	select ChiTietSach.MaSach, Ten, TacGia, NCC, NgonNgu, KhuVuc, TheLoai, KeSach, GiaGoc, GiaBan, Path, BanSach.Code, TonKho, BanSach.LuotMua 
	from Sales.BanSach join Book.ChiTietSach on Sales.BanSach.MaSach = Book.ChiTietSach.MaSach
	where NCC = @ncc;

GO
/****** Object:  StoredProcedure [dbo].[spLaySachTheoTen]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLaySachTheoTen]
	@ten nvarchar(100) = N'%'
as
	select ChiTietSach.MaSach, Ten, TacGia, NCC, NgonNgu, KhuVuc, TheLoai, KeSach, GiaGoc, GiaBan, BanSach.Code, TonKho, BanSach.LuotMua, ChiTietSach.Path
	from Sales.BanSach join Book.ChiTietSach on Sales.BanSach.MaSach = Book.ChiTietSach.MaSach
	where Ten like @ten;

GO
/****** Object:  StoredProcedure [dbo].[spLayTenDangNhap]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayTenDangNhap]
as
	select Username
	from Employee.DangNhap;

GO
/****** Object:  StoredProcedure [dbo].[spLayTenNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayTenNV]
	@manv nchar(9)
as
	select HoTen
	from Employee.NhanSu
	where MaNV = @manv;

GO
/****** Object:  StoredProcedure [dbo].[spLayTenSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayTenSach]
as
	select Ten
	from Book.ChiTietSach;

GO
/****** Object:  StoredProcedure [dbo].[spLayTenTacGia]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spLayTenTacGia]
as
	select distinct TacGia
	from Book.ChiTietSach;

GO
/****** Object:  StoredProcedure [dbo].[spSuaKH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaKH]
	@id nvarchar(20),
	@ten nvarchar(50),
	@d int
as
	update Sales.KhachHang set TenKH = @ten, DiemTich = @d where MaKH = @id;

GO
/****** Object:  StoredProcedure [dbo].[spSuaMGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spSuaMGG]
	@MaMgg nvarchar(50),
	@Ngaybatdau date,
	@Ngayketthuc date,
	@Chitiet nvarchar(100),
	@Phantramgiam decimal(18,2)
as
	update Book.GiamGia set NgayBatDau = @Ngaybatdau, NgayKetThuc = @Ngayketthuc, PhanTramGiam = @Phantramgiam, ChiTiet = @Chitiet
	where MaGiamGia = @MaMgg;	

GO
/****** Object:  StoredProcedure [dbo].[spSuaNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaNCC]
	@mancc nvarchar(50),
	@ten nvarchar (50),
	@sdt nvarchar(50),
	@dc nvarchar(100)
as
	update Book.NhaCungCap set TenNCC = @ten, SDT = @sdt, DiaChi = @dc where MaNCC = @mancc;

GO
/****** Object:  StoredProcedure [dbo].[spSuaNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaNH]
	@madon nvarchar(50),
	@ngaynhan date,
	@nguoinhan nchar(9),
	@vitri nvarchar(50)
as
	update Sales.NhapHang set NgayNhan = @ngaynhan, NguoiNhan = @nguoinhan, ViTri = @vitri where MaDon = @madon;

GO
/****** Object:  StoredProcedure [dbo].[spSuaNV1]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spSuaNV1]
	@manv nchar(9),
	@hoten nvarchar(50),
	@diachi nvarchar(100),
	@sdt nvarchar(20),
	@congviec nvarchar(50),
	@path nvarchar (100)
as
	update Employee.NhanSu set HoTen = @hoten, SDT = @sdt, CongViec = @congviec, DiaChi = @diachi, Path = @path where MaNV = @manv;

GO
/****** Object:  StoredProcedure [dbo].[spSuaNV2]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaNV2]
	@manv nchar(9),
	@hoten nvarchar(50),
	@diachi nvarchar(100),
	@sdt nvarchar(20),
	@congviec nvarchar(50),
	@password nvarchar (50),
	@path nvarchar (100)
as
	update Employee.NhanSu 
	set HoTen = @hoten, SDT = @sdt, CongViec = @congviec, DiaChi = @diachi, Path = @path
	where MaNV = @manv;
	update Employee.DangNhap
	set Pass = @password
	where Username = @manv;

GO
/****** Object:  StoredProcedure [dbo].[spSuaSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spSuaSach]
	@masach int,
	@tensach nvarchar(100),
	@tacgia nvarchar(100),
	@ngonngu nvarchar(50),
	@nxb nvarchar(50),
	@khuvuc nvarchar(50),
	@theloai nvarchar(50),
	@kesach int,
	@giagoc money,
	@giaban money,
	@tonkho int,
	@code nvarchar (50),
	@path nvarchar(100) 
as
	update Book.ChiTietSach set Ten = @tensach, TacGia = @tacgia, NgonNgu = @ngonngu, NCC = @nxb, KhuVuc = @khuvuc, TheLoai = @theloai, KeSach  = @kesach, GiaGoc = @giagoc, Path = @path
	where MaSach = @masach;
	update Sales.BanSach set GiaBan = @giaban, TonKho = @tonkho, Code = @code
	where MaSach = @masach;

GO
/****** Object:  StoredProcedure [dbo].[spThemChiTietHD]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemChiTietHD]
	@mahd nvarchar(50),
	@masach int,
	@sl int,
	@thanhtien money
as
	insert into Sales.ChiTietHD values (@mahd, @masach, @sl, @thanhtien);

GO
/****** Object:  StoredProcedure [dbo].[spThemChiTietNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemChiTietNH]
	@madon nvarchar(50),
	@masach int,
	@soluong int,
	@thanhtien money
as
	insert into Sales.ChiTietNH values (@madon, @masach, @soluong, @thanhtien)

GO
/****** Object:  StoredProcedure [dbo].[spThemDoanhThu]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemDoanhThu] 
	@thangnam nvarchar(50),
	@banhang decimal,
	@nhaphang decimal,
	@doanhthuthang money
as 
	insert into Sales.ThuNhapThang values (@thangnam, @banhang, @nhaphang, @doanhthuthang);

GO
/****** Object:  StoredProcedure [dbo].[spThemHD]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemHD]
	@mahd nvarchar(50),
	@date date,
	@tong money,
	@makh nvarchar(20),
	@manv nchar(9)
as
	insert into Sales.HoaDon values (@mahd, @date, @tong, @makh, @manv);

GO
/****** Object:  StoredProcedure [dbo].[spThemKh]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemKh]
	@id nvarchar(20),
	@ten nvarchar(50),
	@d int
as
	insert into Sales.KhachHang values (@id, @ten, @d);

GO
/****** Object:  StoredProcedure [dbo].[spThemLuotMua]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemLuotMua]
	@masach int,
	@luotmua int
as
	declare @lm int;
	select @lm = LuotMua
	from Sales.BanSach
	where MaSach = @masach;
	set @lm = @lm + @luotmua;
	update Sales.BanSach set LuotMua = @lm where MaSach = @masach;

GO
/****** Object:  StoredProcedure [dbo].[spThemMaGGTheoDongSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemMaGGTheoDongSach]
	@dongs nvarchar (50),
	@code nvarchar (50)
as
	update Sales.BanSach 
	set Code = @code
	from Sales.BanSach inner join Book.ChiTietSach on BanSach.MaSach = ChiTietSach.MaSach
	where ChiTietSach.KhuVuc = @dongs;

GO
/****** Object:  StoredProcedure [dbo].[spThemMGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemMGG]
	@Code nvarchar(50),
	@Ngaybatdau date,
	@Ngayketthuc date,
	@Chitiet nvarchar(100),
	@Phantramgiam decimal(18,2)
as
	insert into Book.GiamGia values (@Code, @Ngaybatdau, @Ngayketthuc, @Chitiet, @Phantramgiam);

GO
/****** Object:  StoredProcedure [dbo].[spThemNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemNCC]
	@mancc nvarchar(50),
	@ten nvarchar (50),
	@sdt nvarchar(50),
	@dc nvarchar(100)
as
	insert into Book.NhaCungCap values (@mancc, @ten, @sdt, @dc);

GO
/****** Object:  StoredProcedure [dbo].[spThemNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemNH]
	@madon nvarchar(50),
	@ngaylap date,
	@nguoilap nchar(9),
	@ncc nvarchar(50),
	@tong money
as
	insert into Sales.NhapHang values (@madon, @ngaylap, @nguoilap, @ncc, @tong, null, null, null);

GO
/****** Object:  StoredProcedure [dbo].[spThemNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemNV]
	@manv nchar(9),
	@hoten nvarchar(50),
	@diachi nvarchar(100),
	@sdt nvarchar(20),
	@congviec nvarchar(50),
	@path nvarchar(100)
as
	insert into Employee.NhanSu values (@manv, @hoten, @diachi, @sdt, @congviec, @path)

GO
/****** Object:  StoredProcedure [dbo].[spThemSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemSach]
	@tensach nvarchar(100),
	@tacgia nvarchar(50),
	@ngonngu nvarchar(50),
	@nxb nvarchar(50),
	@khuvuc nvarchar(50),
	@theloai nvarchar(50),
	@kesach int,
	@giagoc money,
	@giaban money,
	@tonkho int,
	@path nvarchar (100)
as
	insert into Book.ChiTietSach(Ten, TacGia, NgonNgu, NCC, KhuVuc, TheLoai, KeSach, GiaGoc, Path) values (@tensach, @tacgia, @ngonngu, @nxb, @khuvuc, @theloai, @kesach, @giagoc, @path);
	insert into Sales.BanSach values (@@IDENTITY, @giaban, @tonkho, null, 0);

GO
/****** Object:  StoredProcedure [dbo].[spThemSLSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemSLSach]
	@id int,
	@sl int
as
	declare @TK int;
	select @TK = TonKho from Sales.BanSach;
	set @TK = @TK + @sl;
	update Sales.BanSach set TonKho = @TK where MaSach = @id;

GO
/****** Object:  StoredProcedure [dbo].[spThemTienNH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemTienNH] 
	@thangnam nvarchar(50),
	@nhaphang money
as 
	insert into Sales.ThuNhapThang(Thang, TienNhapHang) values (@thangnam, @nhaphang);

GO
/****** Object:  StoredProcedure [dbo].[spThemTienTraNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemTienTraNV] 
	@thangnam nvarchar(50),
	@nv money
as 
	insert into Sales.ThuNhapThang(Thang, TienTraNV) values (@thangnam, @nv);

GO
/****** Object:  StoredProcedure [dbo].[spXoaDoanhThu]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaDoanhThu]
	@thang nvarchar(50)
as
	delete Sales.ThuNhapThang where Thang = @thang;

GO
/****** Object:  StoredProcedure [dbo].[spXoaKH]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaKH]
	@id nvarchar(20)
as
	delete Sales.KhachHang where MaKH = @id;

GO
/****** Object:  StoredProcedure [dbo].[spXoaMGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaMGG]
	@code nvarchar(50)
as
	delete Book.GiamGia where MaGiamGia = @code;

GO
/****** Object:  StoredProcedure [dbo].[spXoaNCC]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaNCC]
	@mancc nvarchar(50)
as
	delete Book.NhaCungCap where MaNCC = @mancc;

GO
/****** Object:  StoredProcedure [dbo].[spXoaNVTheoMa]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaNVTheoMa]
	@manv nchar(9)
as
	delete Employee.NhanSu where MaNV = @manv;

GO
/****** Object:  StoredProcedure [dbo].[spXoaSach]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaSach]
	@MaS int = null
as
	delete from Sales.BanSach where MaSach = @MaS;
	delete from Book.ChiTietSach where MaSach = @MaS;

GO
/****** Object:  Trigger [Book].[tgDelete_ChiTietSach1]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [Book].[tgDelete_ChiTietSach1] on [Book].[ChiTietSach] instead of delete
as
	declare @masmax int, @mas int;
	select @mas = MaSach from deleted;
	delete Sales.ChiTietHD where MaSach = @mas;
	delete Sales.BanSach where MaSach = @mas;
	delete Sales.ChiTietNH where MaSach = @mas;
	delete Book.ChiTietSach where MaSach = @mas;
	select @masmax = max(MaSach)from Book.ChiTietSach;
	if @mas > @masmax
	begin
	set @mas = @masmax;
	DBCC CHECKIDENT ('Book.ChiTietSach', RESEED, @mas);
	end;

GO
/****** Object:  Trigger [Book].[tgXoaMaGG]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [Book].[tgXoaMaGG] on [Book].[GiamGia] instead of delete
as
	declare @code nvarchar(50);
	select @code = MaGiamGia from deleted;
	update Sales.BanSach set Code = null where Code = @code;
	delete Book.GiamGia where MaGiamGia = @code;


GO
/****** Object:  Trigger [Employee].[tgThemNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [Employee].[tgThemNV] on [Employee].[NhanSu] after insert
as
	declare @MaNV nchar(9), @CV nvarchar (50)
	select @MaNV = MaNV, @CV = CongViec from inserted;
	if (@CV != N'Nhân viên bán hàng') insert into Employee.DangNhap values (@MaNV, @MaNV);

GO
/****** Object:  Trigger [Employee].[tgXoaNV]    Script Date: 12/14/2019 9:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [Employee].[tgXoaNV] on [Employee].[NhanSu] instead of delete
as
	declare @manv nchar(9);
	select @manv = MaNV from deleted;
	delete Employee.DangNhap where Username = @manv;
	delete Employee.NhanSu where MaNV = @manv;

GO
USE [master]
GO
ALTER DATABASE [Bookstore] SET  READ_WRITE 
GO
