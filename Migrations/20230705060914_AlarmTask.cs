using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class AlarmTask : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AlarmsTasks",
                columns: table => new
                {
                    AlarmTaskId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AlarmId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TaskText = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AlarmsTasks", x => x.AlarmTaskId);
                    table.ForeignKey(
                        name: "FK_AlarmsTasks_Alarms_AlarmId",
                        column: x => x.AlarmId,
                        principalTable: "Alarms",
                        principalColumn: "AlarmId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "TaskMembers",
                columns: table => new
                {
                    TaskMemberId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AlarmTaskId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MemberId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IsDone = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TaskMembers", x => x.TaskMemberId);
                    table.ForeignKey(
                        name: "FK_TaskMembers_AlarmsTasks_AlarmTaskId",
                        column: x => x.AlarmTaskId,
                        principalTable: "AlarmsTasks",
                        principalColumn: "AlarmTaskId",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_TaskMembers_Members_MemberId",
                        column: x => x.MemberId,
                        principalTable: "Members",
                        principalColumn: "MemberGroupId",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AlarmsTasks_AlarmId",
                table: "AlarmsTasks",
                column: "AlarmId");

            migrationBuilder.CreateIndex(
                name: "IX_TaskMembers_AlarmTaskId",
                table: "TaskMembers",
                column: "AlarmTaskId");

            migrationBuilder.CreateIndex(
                name: "IX_TaskMembers_MemberId",
                table: "TaskMembers",
                column: "MemberId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TaskMembers");

            migrationBuilder.DropTable(
                name: "AlarmsTasks");
        }
    }
}
