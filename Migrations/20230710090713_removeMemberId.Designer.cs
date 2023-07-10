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
    [Migration("20230710090713_removeMemberId")]
    partial class removeMemberId
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

            modelBuilder.Entity("WeWakeAPI.Models.AlarmTask", b =>
                {
                    b.Property<Guid>("AlarmTaskId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AlarmId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("TaskText")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("AlarmTaskId");

                    b.HasIndex("AlarmId");

                    b.ToTable("AlarmsTasks");
                });

            modelBuilder.Entity("WeWakeAPI.Models.Chat", b =>
                {
                    b.Property<Guid>("MessageId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime2");

                    b.Property<string>("Data")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<Guid>("GroupId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("SenderId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("SenderName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("MessageId");

                    b.ToTable("Chats");
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

            modelBuilder.Entity("WeWakeAPI.Models.OptOut", b =>
                {
                    b.Property<Guid>("OptOutId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AlarmId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<bool>("IsOptOut")
                        .HasColumnType("bit");

                    b.Property<Guid>("MemberId")
                        .HasColumnType("uniqueidentifier");

                    b.HasKey("OptOutId");

                    b.HasIndex("AlarmId");

                    b.ToTable("OptOuts");
                });

            modelBuilder.Entity("WeWakeAPI.Models.TaskMember", b =>
                {
                    b.Property<Guid>("TaskMemberId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("AlarmTaskId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<bool>("IsDone")
                        .HasColumnType("bit");

                    b.Property<Guid>("MemberId")
                        .HasColumnType("uniqueidentifier");

                    b.HasKey("TaskMemberId");

                    b.HasIndex("AlarmTaskId");

                    b.ToTable("TaskMembers");
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

            modelBuilder.Entity("WeWakeAPI.Models.AlarmTask", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Alarm", "Alarm")
                        .WithMany()
                        .HasForeignKey("AlarmId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Alarm");
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

            modelBuilder.Entity("WeWakeAPI.Models.OptOut", b =>
                {
                    b.HasOne("WeWakeAPI.Models.Alarm", "Alarm")
                        .WithMany()
                        .HasForeignKey("AlarmId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Alarm");
                });

            modelBuilder.Entity("WeWakeAPI.Models.TaskMember", b =>
                {
                    b.HasOne("WeWakeAPI.Models.AlarmTask", "AlarmTask")
                        .WithMany()
                        .HasForeignKey("AlarmTaskId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("AlarmTask");
                });
#pragma warning restore 612, 618
        }
    }
}
