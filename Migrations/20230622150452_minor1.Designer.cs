﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using WeWakeAPI.Data;

#nullable disable

namespace WeWakeAPI.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    [Migration("20230622150452_minor1")]
    partial class minor1
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.7")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("WeWakeAPI.Models.Alarm", b =>
                {
                    b.Property<Guid>("AlarmId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("GroupId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<bool>("IsEnabled")
                        .HasColumnType("bit");

                    b.Property<DateTime>("Time")
                        .HasColumnType("datetime2");

                    b.HasKey("AlarmId");

                    b.ToTable("Alarms");
                });

            modelBuilder.Entity("WeWakeAPI.Models.AlarmOptions", b =>
                {
                    b.Property<Guid>("AlarmOptionsId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AlarmId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("AudioURL")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("InternalAudioFile")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("NotificationBody")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("NotificationTitle")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("UseExternalAudio")
                        .HasColumnType("bit");

                    b.Property<bool>("loopAudio")
                        .HasColumnType("bit");

                    b.Property<bool>("vibrate")
                        .HasColumnType("bit");

                    b.HasKey("AlarmOptionsId");

                    b.HasIndex("AlarmId");

                    b.ToTable("AlarmOptions");
                });

            modelBuilder.Entity("WeWakeAPI.Models.Group", b =>
                {
                    b.Property<Guid>("GroupId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AdminId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime2");

                    b.Property<string>("GroupName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("GroupId");

                    b.ToTable("Groups");
                });

            modelBuilder.Entity("WeWakeAPI.Models.Member", b =>
                {
                    b.Property<Guid>("MemberGroupId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("GroupId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("MemberId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<bool>("isAdmin")
                        .HasColumnType("bit");

                    b.HasKey("MemberGroupId");

                    b.ToTable("Members");
                });

            modelBuilder.Entity("WeWakeAPI.Models.User", b =>
                {
                    b.Property<Guid>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("WeWakeAPI.Models.AlarmOptions", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Alarm", "Alarm")
                        .WithMany()
                        .HasForeignKey("AlarmId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Alarm");
                });
#pragma warning restore 612, 618
        }
    }
}
