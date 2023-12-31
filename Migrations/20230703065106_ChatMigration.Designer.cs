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
    [Migration("20230703065106_ChatMigration")]
    partial class ChatMigration
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

                    b.Property<int>("AlarmAppId")
                        .HasColumnType("int");

                    b.Property<string>("AudioURL")
                        .HasColumnType("nvarchar(max)");

                    b.Property<Guid>("CreatedBy")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("GroupId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("InternalAudioFile")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsEnabled")
                        .HasColumnType("bit");

                    b.Property<bool>("LoopAudio")
                        .HasColumnType("bit");

                    b.Property<string>("NotificationBody")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("NotificationTitle")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("Time")
                        .HasColumnType("datetime2");

                    b.Property<bool>("UseExternalAudio")
                        .HasColumnType("bit");

                    b.Property<bool>("Vibrate")
                        .HasColumnType("bit");

                    b.HasKey("AlarmId");

                    b.HasIndex("GroupId");

                    b.ToTable("Alarms");
                });

            modelBuilder.Entity("WeWakeAPI.Models.Group", b =>
                {
                    b.Property<Guid>("GroupId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AdminId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<bool>("CanMemberCreateAlarm")
                        .HasColumnType("bit");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime2");

                    b.Property<string>("GroupName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("GroupId");

                    b.ToTable("Groups");
                });

            modelBuilder.Entity("WeWakeAPI.Models.InviteLink", b =>
                {
                    b.Property<Guid>("InviteLinkId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("GroupId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("InviterId")
                        .HasColumnType("uniqueidentifier");

                    b.HasKey("InviteLinkId");

                    b.HasIndex("GroupId");

                    b.ToTable("InviteLinks");
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

                    b.HasIndex("GroupId");

                    b.HasIndex("MemberId");

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

            modelBuilder.Entity("WeWakeAPI.Models.Alarm", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Group", "Group")
                        .WithMany()
                        .HasForeignKey("GroupId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Group");
                });

            modelBuilder.Entity("WeWakeAPI.Models.InviteLink", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Group", "Group")
                        .WithMany()
                        .HasForeignKey("GroupId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Group");
                });

            modelBuilder.Entity("WeWakeAPI.Models.Member", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Group", "Group")
                        .WithMany()
                        .HasForeignKey("GroupId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("WeWakeAPI.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("MemberId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Group");

                    b.Navigation("User");
                });
#pragma warning restore 612, 618
        }
    }
}
