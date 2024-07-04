import pandas as pd
import argparse
from pathlib import Path
import matplotlib.pyplot as plt

SCRIPT_DIR = Path(__file__).parent


def main():
    parser = argparse.ArgumentParser(
        description="Get kinematic or dynamic info from rosbag in csv format"
    )
    parser.add_argument(
        "--model",
        "-m",
        type=str,
        required=True,
        choices=[
            "time",
            "kinematics",
            "validation",
            "movement",
            "dynamics",
            "steering",
        ],
        help="Which model to output data to",
    )
    parser.add_argument(
        "--input_csv",
        "-i",
        type=str,
        required=False,
        default="data/rosbag2_2024_06_27-03_51_44.csv",
        help="Input rosbag .csv file",
    )
    parser.add_argument(
        "--save_output",
        "-s",
        action="store_true",
        required=False,
        help="Wheter to save the output .csv file",
    )
    parser.add_argument(
        "--output_csv",
        "-o",
        type=str,
        required=False,
        help="Output .csv file",
    )
    args = parser.parse_args()

    data = pd.read_csv(SCRIPT_DIR / args.input_csv)
    print(data.columns)
    if args.model == "time":
        data = data[
            [
                "__time",
                "/ground_truth/header/header/stamp",
                "/joint_states/header/stamp",
            ]
        ]
        data = data - data.iloc[0]
        data.plot()
        plt.show()
        print(data.describe())
        print(data.columns)
        print(data["/ground_truth/header/header/stamp"])
    elif args.model == "kinematics":
        data = data[
            [
                "__time",
                "/ground_truth/pose/pose/position/x",
                "/ground_truth/pose/pose/position/y",
                "/ground_truth/pose/pose/position/z",
                "/ground_truth/pose/pose/orientation/yaw",
                "/joint_states/header/stamp",
                "/joint_states/front_left_motor_joint/position",
                "/joint_states/front_left_wheel_joint/velocity",
                "/joint_states/front_right_motor_joint/position",
                "/joint_states/front_right_wheel_joint/velocity",
                "/joint_states/rear_left_motor_joint/position",
                "/joint_states/rear_left_wheel_joint/velocity",
                "/joint_states/rear_right_motor_joint/position",
                "/joint_states/rear_right_wheel_joint/velocity",
            ]
        ]
    elif args.model == "validation":
        data = data[
            [
                "__time",
                "/ground_truth/pose/pose/position/x",
                "/ground_truth/pose/pose/position/y",
                "/ground_truth/pose/pose/position/z",
                "/ground_truth/pose/pose/orientation/yaw",
                "/joint_states/front_left_motor_joint/position",
                "/joint_states/front_left_wheel_joint/velocity",
                "/joint_states/front_right_motor_joint/position",
                "/joint_states/front_right_wheel_joint/velocity",
                "/joint_states/rear_left_motor_joint/position",
                "/joint_states/rear_left_wheel_joint/velocity",
                "/joint_states/rear_right_motor_joint/position",
                "/joint_states/rear_right_wheel_joint/velocity",
                "/imu/linear_acceleration/x",
                "/imu/linear_acceleration/y",
                "/imu/linear_acceleration/z",
            ]
        ]
    elif args.model == "movement":
        data = data[
            [
                "__time",
                "/ground_truth/pose/pose/position/x",
                "/ground_truth/pose/pose/position/y",
                "/ground_truth/pose/pose/position/z",
                "/ground_truth/pose/pose/orientation/yaw",
            ]
        ]
    elif args.model == "dynamics":
        data = data[
            [
                "__time",
                "/ground_truth/pose/pose/position/x",
                "/ground_truth/pose/pose/position/y",
                "/ground_truth/pose/pose/position/z",
                "/ground_truth/pose/pose/orientation/yaw",
                "/ground_truth/twist/twist/linear/x",
                "/ground_truth/twist/twist/linear/y",
                "/ground_truth/twist/twist/linear/z",
                "/ground_truth/twist/twist/angular/z",
                "/joint_states/header/stamp",
                "/joint_states/front_left_motor_joint/position",
                "/joint_states/front_left_wheel_joint/effort",
                "/joint_states/front_right_motor_joint/position",
                "/joint_states/front_right_wheel_joint/effort",
                "/joint_states/rear_left_motor_joint/position",
                "/joint_states/rear_left_wheel_joint/effort",
                "/joint_states/rear_right_motor_joint/position",
                "/joint_states/rear_right_wheel_joint/effort",
            ]
        ]
    elif args.model == "steering":
        data = data[
            [
                "__time",
                "/effort_controller/commands/data[1]",
                "/joint_states/front_left_wheel_joint/effort",
                "/joint_states/front_left_motor_joint/position",
                "/joint_states/front_left_motor_joint/velocity",
            ]
        ]
        print(data["__time"])
        data = data.ffill().fillna(0)
        data = data[(data["__time"] >= 1718737782) & (data["__time"] <= 1718737802)]
        data[
            [
                "__time",
                "/effort_controller/commands/data[1]",
                "/joint_states/front_left_motor_joint/position",
            ]
        ].plot(x="__time")
        plt.show()
    data = data.ffill().fillna(0)
    print(data.columns)
    if args.save_output:
        assert (
            args.output_csv is not None
        ), "Argument --output_csv has to be set in order to save the output"
        data.to_csv(SCRIPT_DIR / args.output_csv, index=False)
        print(f"saved to: {str(SCRIPT_DIR / args.output_csv)}")


main()
