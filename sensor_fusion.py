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
        required=False,
        choices=[
            "fusion",
        ],
        default="fusion",
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
    parser.add_argument(
        "--output_fig",
        "-f",
        type=str,
        required=False,
        help="Output .png files",
    )
    args = parser.parse_args()

    data = pd.read_csv(SCRIPT_DIR / args.input_csv)
    print(data.columns)
    if args.model == "fusion":
        data = data[
            [
                "__time",
                "/ground_truth/pose/pose/position/x",
                "/ground_truth/pose/pose/position/y",
                "/ground_truth/pose/pose/position/z",
                "/ground_truth/pose/pose/orientation/yaw",
                "/odometry/filtered/point/x",
                "/odometry/filtered/point/y",
                "/odometry/filtered/point/z",
            ]
        ]
        data = data.ffill().fillna(0)
        data["__time"] = data["__time"] - data["__time"].iloc[0]
        data["abs_error_x"] = abs(
            data["/odometry/filtered/point/x"]
            - data["/ground_truth/pose/pose/position/x"]
        )
        data["abs_error_y"] = abs(
            data["/odometry/filtered/point/y"]
            - data["/ground_truth/pose/pose/position/y"]
        )
        data["abs_error_xy"] = abs(
            data["/odometry/filtered/point/x"]
            - data["/ground_truth/pose/pose/position/x"]
        ) + abs(
            data["/odometry/filtered/point/y"]
            - data["/ground_truth/pose/pose/position/y"]
        )

        plt.rc("lines", linewidth=2.0)
        fig_size = [8, 7]
        dpi_ = 800

        figx, (axxu, axxd) = plt.subplots(2, 1, figsize=fig_size)
        figx.suptitle("Análise da fusão de sensores no eixo x")
        axxu.plot(data["__time"], data["/odometry/filtered/point/x"], label="Estimação")
        axxu.plot(
            data["__time"],
            data["/ground_truth/pose/pose/position/x"],
            dashes=[6, 2],
            label="Posição verdadeira",
        )
        axxu.set_xlabel("Tempo [s]")
        axxu.set_ylabel("Distância [m]")
        axxu.legend()
        axxd.plot(
            data["__time"],
            data["abs_error_x"],
            label="Erro absoluto de estimação [m]",
        )
        axxd.set_xlabel("Tempo [s]")
        axxd.set_ylabel("Distância [m]")
        mean_abs_error_x = data["abs_error_x"].mean()
        axxd.axhline(
            y=mean_abs_error_x,
            color="r",
            linestyle="-.",
            label=f"Média do erro absoluto: {mean_abs_error_x:4f} [m]",
        )
        axxd.legend()
        plt.tight_layout()
        if args.output_fig is not None:
            figx.savefig(fname=SCRIPT_DIR / f"{args.output_fig}_x.png", dpi=dpi_)

        figy, (axyu, axyd) = plt.subplots(2, 1, figsize=fig_size)
        figy.suptitle("Análise da fusão de sensores no eixo y")
        axyu.plot(data["__time"], data["/odometry/filtered/point/y"], label="Estimação")
        axyu.plot(
            data["__time"],
            data["/ground_truth/pose/pose/position/y"],
            dashes=[6, 2],
            label="Posição verdadeira",
        )
        axyu.set_xlabel("Tempo [s]")
        axyu.set_ylabel("Distância [m]")
        axyu.legend()
        axyd.plot(
            data["__time"],
            data["abs_error_y"],
            label="Erro absoluto de estimação [m]",
        )
        axyd.set_xlabel("Tempo [s]")
        axyd.set_ylabel("Distância [m]")
        mean_abs_error_y = data["abs_error_y"].mean()
        axyd.axhline(
            y=mean_abs_error_y,
            color="r",
            linestyle="-.",
            label=f"Média do erro absoluto: {mean_abs_error_y:4f} [m]",
        )
        axyd.legend()
        plt.tight_layout()
        if args.output_fig is not None:
            figy.savefig(fname=SCRIPT_DIR / f"{args.output_fig}_y.png", dpi=dpi_)

        figxy, (axxyu, axxyd) = plt.subplots(2, 1, figsize=fig_size)
        figxy.suptitle("Análise da fusão de sensores no plano x-y")
        axxyu.plot(
            data["/odometry/filtered/point/x"],
            data["/odometry/filtered/point/y"],
            label="Estimação",
        )
        axxyu.plot(
            data["/ground_truth/pose/pose/position/x"],
            data["/ground_truth/pose/pose/position/y"],
            dashes=[2, 6],
            label="Posição verdadeira",
        )
        axxyu.set_xlabel("Distância em x [m]")
        axxyu.set_ylabel("Distância em y [m]")
        axxyu.legend()
        axxyd.plot(
            data["__time"],
            data["abs_error_xy"],
            label="Erro absoluto de estimação [m]",
        )
        axxyd.set_xlabel("Tempo [s]")
        axxyd.set_ylabel("Distância [m]")
        mean_abs_error_xy = data["abs_error_xy"].mean()
        axxyd.axhline(
            y=mean_abs_error_xy,
            color="r",
            linestyle="-.",
            label=f"Média do erro absoluto: {mean_abs_error_y:4f} [m]",
        )
        axxyd.legend()
        plt.tight_layout()
        if args.output_fig is not None:
            figxy.savefig(fname=SCRIPT_DIR / f"{args.output_fig}_xy.png", dpi=dpi_)
        # plt.show()
        print(data.columns)

    if args.save_output:
        assert (
            args.output_csv is not None
        ), "Argument --output_csv has to be set in order to save the output"
        data.to_csv(SCRIPT_DIR / args.output_csv, index=False)
        print(f"saved to: {str(SCRIPT_DIR / args.output_csv)}")


main()
