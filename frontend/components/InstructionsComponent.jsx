import styles from "../styles/InstructionsComponent.module.css";
import Router, { useRouter } from "next/router";
import { useAccount, usePrepareContractWrite, useContractWrite, useWaitForTransaction } from "wagmi";
import abi from "../utils/contractAbi.json";
export default function InstructionsComponent() {
	const router = useRouter();
	const { address, connector, isConnected } = useAccount();
	const { config } = usePrepareContractWrite({
		address: '0xBBF6a943dada04880C6766F1CAF03a7E7d5E2873',
		abi: abi,
		functionName: 'makeAnEpicNFT',
	})

	function handleMint() {
		if (!isConnected) {
			alert("Please connect your wallet")
			return;
		}
		write();
	}

	const { data, write } = useContractWrite(config)
	const { isLoading, isSuccess } = useWaitForTransaction({
		hash: data?.hash,
	})

	return (
		<div className={styles.container}>
			<header className={styles.header_container}>
				<h1>
					<span>Epic</span> NFTs
				</h1>
				<p>
					Mint your NFT now!
				</p>
			</header>

			<div className={styles.buttons_container}>
				<div className={styles.button} disabled={!write || isLoading} onClick={handleMint}>
					{isLoading ? 'Minting...' : 'Mint'}
				</div>
				{isSuccess && (
					<div>
						Successfully minted your NFT!
						<div>
							<a href={`https://mumbai.polygonscan.com/tx/${data?.hash}`}>View on Polygon Scan</a>
						</div>
					</div>
				)}
			</div>
			{/* <div className={styles.footer}>
				<a href="https://alchemy.com/?a=create-web3-dapp" target={"_blank"}>
					<img
						id="badge-button"
						style={{ width: "240px", height: "53px" }}
						src="https://static.alchemyapi.io/images/marketing/badgeLight.png"
						alt="Alchemy Supercharged"
					/>
				</a>
				<div className={styles.icons_container}>
					<div>
						<a
							href="https://github.com/alchemyplatform/create-web3-dapp"
							target={"_blank"}
						>
							Leave a star on Github
						</a>
					</div>
					<div>
						<a
							href="https://twitter.com/AlchemyPlatform"
							target={"_blank"}
						>
							Follow us on Twitter
						</a>
					</div>
				</div>
			</div> */}
		</div>
	);
}