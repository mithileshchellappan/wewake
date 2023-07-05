using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class RemoveFK : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TaskMembers_AlarmsTasks_AlarmTaskId",
                table: "TaskMembers");

            migrationBuilder.DropForeignKey(
                name: "FK_TaskMembers_Members_MemberId",
                table: "TaskMembers");

            migrationBuilder.DropIndex(
                name: "IX_TaskMembers_MemberId",
                table: "TaskMembers");

            migrationBuilder.AddForeignKey(
                name: "FK_TaskMembers_AlarmsTasks_AlarmTaskId",
                table: "TaskMembers",
                column: "AlarmTaskId",
                principalTable: "AlarmsTasks",
                principalColumn: "AlarmTaskId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TaskMembers_AlarmsTasks_AlarmTaskId",
                table: "TaskMembers");

            migrationBuilder.CreateIndex(
                name: "IX_TaskMembers_MemberId",
                table: "TaskMembers",
                column: "MemberId");

            migrationBuilder.AddForeignKey(
                name: "FK_TaskMembers_AlarmsTasks_AlarmTaskId",
                table: "TaskMembers",
                column: "AlarmTaskId",
                principalTable: "AlarmsTasks",
                principalColumn: "AlarmTaskId");

            migrationBuilder.AddForeignKey(
                name: "FK_TaskMembers_Members_MemberId",
                table: "TaskMembers",
                column: "MemberId",
                principalTable: "Members",
                principalColumn: "MemberGroupId");
        }
    }
}
