using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class FKGroupIdInAlarm : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "Alarms",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_Alarms_GroupId",
                table: "Alarms",
                column: "GroupId");

            migrationBuilder.AddForeignKey(
                name: "FK_Alarms_Groups_GroupId",
                table: "Alarms",
                column: "GroupId",
                principalTable: "Groups",
                principalColumn: "GroupId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Alarms_Groups_GroupId",
                table: "Alarms");

            migrationBuilder.DropIndex(
                name: "IX_Alarms_GroupId",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "Alarms");
        }
    }
}
